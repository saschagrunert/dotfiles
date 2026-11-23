"""Behavioral checks for status scripts, without desktop services or network access."""

import base64
import json
import os
import re
import select
import shutil
import signal
import subprocess
import tempfile
import time
import unittest
from datetime import datetime, timedelta
from pathlib import Path
from zoneinfo import ZoneInfo

ROOT = Path(__file__).resolve().parents[1]


class StatusTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-status-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.scripts = self.root / "waybar"
        shutil.copytree(ROOT / "waybar", self.scripts)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.runtime = self.root / "runtime"
        self.runtime.mkdir()
        self.cache = self.root / "cache"
        self.credentials = self.root / "credentials"
        self.hwmon = self.root / "hwmon"
        self.hwmon.mkdir()
        self.env = os.environ | {
            "PATH": str(self.bin) + os.pathsep + os.environ["PATH"],
            "XDG_RUNTIME_DIR": str(self.runtime),
            "XDG_CACHE_HOME": str(self.cache),
            "CLAUDE_CONFIG_DIR": str(self.credentials),
            "CODEX_HOME": str(self.root / "codex"),
            "XDG_STATE_HOME": str(self.root / "state"),
            "HWMON_ROOT": str(self.hwmon),
            "RAPL_ROOT": str(self.root / "rapl"),
            "NIX_UPDATES_FLAKE": str(self.root),
            "NIX_UPDATES_HOST": "test",
            "NIX_UPDATES_TIMEOUT": "1",
        }
        (self.root / "flake.lock").write_text("{}")
        self.command("sleep", "exit 0")
        self.command("ip", "exit 1")
        self.command("nmcli", "exit 1")
        self.command("nm-online", "exit 2")
        self.command("nix", "exit 1")
        self.command("curl", "exit 1")
        # Codex sessions running on this machine must not show up.
        self.command("pgrep", "exit 1")

    def command(self, name, body):
        path = self.bin / name
        path.write_text("#!/usr/bin/env bash\nset -eu\n" + body + "\n")
        path.chmod(0o755)

    def run_script(self, name, scenario=None, args=("--once",)):
        path = self.scripts / name
        if scenario is not None:
            source = path.read_text()
            source = source.removesuffix('run emit "${1:-}"\n')
            path.write_text(source + "\n" + scenario + "\n")
        return subprocess.run(
            ["bash", str(path), *args],
            env=self.env,
            capture_output=True,
            text=True,
            check=True,
            timeout=10,
        ).stdout

    def payload(self, name, scenario=None):
        data = json.loads(self.run_script(name, scenario))
        self.assertIsInstance(data["text"], str)
        return data

    def test_missing_sensors_are_unavailable(self):
        for name in ("temps", "power", "fans", "gpu"):
            with self.subTest(name=name):
                data = self.payload(name)
                self.assertIn("N/A", data["text"])
                self.assertIn("N/A", data["tooltip"])
                self.assertNotEqual(data.get("class"), "critical")

    def test_zero_temperature_and_stopped_fan_are_real_readings(self):
        cpu = self.hwmon / "hwmon0"
        cpu.mkdir()
        (cpu / "name").write_text("k10temp\n")
        (cpu / "temp1_input").write_text("0\n")
        self.assertIn("0°C", self.payload("temps")["tooltip"])
        gpu = self.hwmon / "hwmon1"
        gpu.mkdir()
        (gpu / "name").write_text("amdgpu\n")
        (gpu / "fan1_input").write_text("0\n")
        self.assertIn("0 RPM", self.payload("fans")["tooltip"])

    def gpu_fixture(self):
        gpu = self.hwmon / "hwmon0"
        (gpu / "device").mkdir(parents=True)
        for name, value in {
            "name": "amdgpu",
            "fan1_input": "0",
            "power1_average": "150900000",
            "power1_cap": "262900000",
        }.items():
            (gpu / name).write_text(value + "\n")
        return gpu

    def test_gpu_power_and_cap_are_rounded(self):
        self.gpu_fixture()
        data = self.payload(
            "power",
            """percent() { printf '%s %s\\n' "$1" "$2" >>"$XDG_RUNTIME_DIR/limits"; echo 0; }
emit""",
        )
        self.assertRegex(data["text"], r"\b151 W")
        self.assertIn("151 263", (self.runtime / "limits").read_text().splitlines())

    def test_power_rows_fill_tooltip_width(self):
        rows = self.run_script(
            "power",
            """for value in 0 41 151; do
    row 'CPU  ' "$value" 162
    printf '\\n'
    row 'GPU  ' "$value" 263
    printf '\\n'
done""",
        ).splitlines()
        self.assertEqual(len(rows), 6)
        for row in rows:
            self.assertEqual(len(re.sub("<[^>]*>", "", row)), 49)

    def test_first_gpu_sample_reports_process_load(self):
        self.gpu_fixture()
        script = self.scripts / "gpu"
        source = script.read_text()
        source = source.replace(
            "\nselect_gpu\nclients=$(sample_clients)",
            """
sample_clients() {
    local count=0
    [ ! -f "$XDG_RUNTIME_DIR/samples" ] || read -r count <"$XDG_RUNTIME_DIR/samples"
    count=$((count + 1))
    echo "$count" >"$XDG_RUNTIME_DIR/samples"
    printf '123\\t7\\t%d\\t1024\\tfixture\\n' "$((count * 1000000000))"
}
sample_time() { local count; read -r count <"$XDG_RUNTIME_DIR/samples"; echo "$((count * 1000000))"; }
select_gpu
clients=$(sample_clients)""",
        )
        script.write_text(source)
        plain = re.sub("<[^>]*>", "", self.payload("gpu")["tooltip"])
        self.assertRegex(plain, r"123\s+100%\s+\S+\s+fixture")

    def test_gpu_discovery_is_cached_until_device_disappears(self):
        self.gpu_fixture()
        readlink = shutil.which("readlink")
        self.command(
            "readlink",
            f'echo lookup >>"$XDG_RUNTIME_DIR/lookups"; exec "{readlink}" "$@"',
        )
        self.run_script(
            "gpu",
            """emit >/dev/null
emit >/dev/null
[[ $(wc -l <"$XDG_RUNTIME_DIR/lookups") == 1 ]]
mv "$HWMON_ROOT/hwmon0" "$HWMON_ROOT/offline"
emit >/dev/null
mv "$HWMON_ROOT/offline" "$HWMON_ROOT/hwmon1"
emit >/dev/null
[[ $(wc -l <"$XDG_RUNTIME_DIR/lookups") == 2 ]]""",
        )

    def test_fan_columns_keep_fixed_widths(self):
        gpu = self.gpu_fixture()
        (gpu / "pwm1").write_text("0\n")
        board = self.hwmon / "hwmon1"
        board.mkdir()
        for name, value in {
            "name": "nct6799",
            "fan2_input": "1200",
            "pwm2": "115",
        }.items():
            (board / name).write_text(value + "\n")
        plain = re.sub("<[^>]*>", "", self.payload("fans")["tooltip"])
        rows = [line for line in plain.splitlines() if "RPM" in line]
        self.assertEqual(len(rows), 2)
        self.assertEqual(rows[0].index("RPM"), rows[1].index("RPM"))
        self.assertEqual(rows[0].index("%"), rows[1].index("%"))

    def test_ipv6_only_connection_is_connected(self):
        self.command(
            "ip",
            """if [[ $* == *"route show default"* ]]; then
    if [[ $* == *-4* ]]; then echo '[]'; else
        echo '[{"dev":"test0","gateway":"fe80::1","metric":100}]'
    fi
else
    echo '[{"addr_info":[{"family":"inet6","scope":"global","local":"2001:db8::2","prefixlen":64}]}]'
fi""",
        )
        data = self.payload(
            "network",
            """counters() { new_rx=1000; new_tx=2000; }
vpns() { :; }
emit""",
        )
        self.assertNotEqual(data["class"], "disconnected")
        self.assertIn("2001:db8::2/64", data["tooltip"])
        self.assertIn("fe80::1", data["tooltip"])

    def test_route_uses_lowest_metric(self):
        self.command(
            "ip",
            """echo '[{"dev":"slow","metric":200},{"dev":"fast","metric":10,"gateway":"192.0.2.1"}]'""",
        )
        self.assertEqual(
            self.run_script("network", "default_route").strip(), "fast 192.0.2.1"
        )

    def test_multipath_default_is_connected(self):
        self.command(
            "ip",
            """echo '[{"metric":10,"nexthops":[{"dev":"uplink","gateway":"192.0.2.1"}]}]'""",
        )
        self.assertEqual(
            self.run_script("network", "default_route").strip(), "uplink 192.0.2.1"
        )

    def test_non_unicast_defaults_are_ignored(self):
        self.command(
            "ip",
            """echo '[{"type":"blackhole","dev":"blocked","metric":0},
{"type":"unreachable","dev":"rejected","metric":1},
{"dev":"uplink","gateway":"192.0.2.1","metric":10}]'""",
        )
        self.assertEqual(
            self.run_script("network", "default_route").strip(), "uplink 192.0.2.1"
        )

    def test_interface_disappearance_does_not_abort(self):
        data = self.payload(
            "network",
            """default_route() { echo 'gone0 192.0.2.1'; }
emit""",
        )
        self.assertIn("unavailable", data["tooltip"])

    def test_disconnected_bar_text_stays_lowercase(self):
        data = self.payload("network")
        self.assertTrue(data["text"].endswith(" disconnected"))
        self.assertEqual(data["tooltip"], "Disconnected")

    def test_network_counter_reset_clears_history(self):
        data = self.payload(
            "network",
            """default_route() { echo 'test0 192.0.2.1'; }
counters() { new_rx=10; new_tx=20; }
vpns() { :; }
iface=test0 rx=100000 tx=200000 time=1
down_history=(99999) up_history=(99999)
emit
[[ ${down_history[*]} == 0 && ${up_history[*]} == 0 ]]""",
        )
        self.assertNotIn("-", data["text"])

    def test_disk_counter_reset_clears_history(self):
        self.payload(
            "disk",
            """sample_disks() { read_bytes=10; write_bytes=20; }
filesystems() { printf '1\\t1000000\\t10000\\t990000\\text4\\t/\\n'; }
read_bytes=100000 write_bytes=200000 time=1
read_history=(99999) write_history=(99999)
emit
[[ ${read_history[*]} == 0 && ${write_history[*]} == 0 ]]""",
        )

    def test_claude_ignores_malformed_cache(self):
        state = self.runtime / "waybar"
        state.mkdir()
        (state / "claude.state.json").write_text('{"limits":[')
        self.assertIn("no credentials", self.payload("claude")["tooltip"])
        json.loads((state / "claude.state.json").read_text())

    def test_claude_does_not_execute_legacy_cache(self):
        state = self.runtime / "waybar"
        state.mkdir()
        marker = self.root / "executed"
        (state / "claude.state").write_text(f"touch '{marker}'\n")
        self.payload("claude")
        self.assertFalse(marker.exists())

    def test_claude_ignores_invalid_snapshot_fields(self):
        state = self.runtime / "waybar"
        state.mkdir()
        (state / "claude.state.json").write_text(
            json.dumps({"limits": ["invalid"], "fetched": "not a timestamp"})
        )
        self.assertIn("no credentials", self.payload("claude")["tooltip"])

    def test_claude_finds_credentials_created_after_startup(self):
        self.command(
            "curl",
            """cat <<'JSON'
{"limits":[{"kind":"weekly_all","percent":25,"resets_at":"2099-01-01T00:00:00Z","is_active":true}]}
200
JSON""",
        )
        data = self.payload(
            "claude",
            """emit >/dev/null
mkdir -p "$CLAUDE_CONFIG_DIR"
printf '{"claudeAiOauth":{"accessToken":"test","expiresAt":9999999999999}}' >"$credentials"
emit""",
        )
        self.assertIn("25%", data["text"])
        self.assertNotIn("No data", data["tooltip"])
        # A second process restores the snapshot without fetching again.
        self.command("curl", "exit 1")
        again = json.loads(
            subprocess.run(
                ["bash", str(self.scripts / "claude")],
                env=self.env,
                capture_output=True,
                text=True,
                check=True,
                timeout=10,
            ).stdout
        )
        self.assertIn("25%", again["text"])
        self.assertNotIn("request failed", again["tooltip"])

    def test_codex_ignores_malformed_state(self):
        state = self.root / "state" / "waybar"
        state.mkdir(parents=True)
        (state / "codex.json").write_text('{"costs":{')
        self.assertIn("no credentials", self.payload("codex")["tooltip"])
        json.loads((state / "codex.json").read_text())

    def test_codex_counts_resumed_sessions(self):
        home = self.root / "codex"
        now = datetime.now()
        then = now - timedelta(days=40)
        new = "01a1e399-0000-7000-8000-000000000001"
        old = "01a1e399-0000-7000-8000-000000000002"
        files = {}
        for sid, start in ((new, now), (old, then)):
            directory = home / "sessions" / start.strftime("%Y/%m/%d")
            directory.mkdir(parents=True)
            files[sid] = directory / f"rollout-{start:%Y-%m-%dT%H-%M-%S}-{sid}.jsonl"
            # The turn context has no effort, which must not shift the cost.
            files[sid].write_text(
                json.dumps(
                    {"type": "turn_context", "payload": {"model": "gpt-test"}},
                    separators=(",", ":"),
                )
                + "\n"
            )
        # A base64url payload, which plain base64 decoding rejects.
        for n in range(64):
            raw = json.dumps({"exp": 9999999999, "pad": "?" * n + ">"}).encode()
            payload = base64.urlsafe_b64encode(raw).decode().rstrip("=")
            if "-" in payload or "_" in payload:
                break
        (home / "auth.json").write_text(
            json.dumps(
                {"tokens": {"access_token": f"h.{payload}.s", "account_id": "a"}}
            )
        )
        # The old session cost $1 when the month started and spent $2 since.
        month = datetime.now(ZoneInfo("America/Los_Angeles")).strftime("%Y-%m")
        state = self.root / "state" / "waybar"
        state.mkdir(parents=True)
        (state / "codex.json").write_text(
            json.dumps(
                {
                    "month": month,
                    "fetched": 0,
                    "updated": 0,
                    "wait": 300,
                    "error": "",
                    "costs": {old: 1000000},
                    "base": {old: 1000000},
                }
            )
        )
        self.command(
            "curl",
            f"""cat >/dev/null
cat <<'JSON'
{{"threads":[{{"thread_id":"{new}","native_usage_usd_micros":5000000}},
{{"thread_id":"{old}","native_usage_usd_micros":3000000}}]}}
JSON
printf 200""",
        )
        data = self.payload(
            "codex",
            f"""exec 3<"{files[new]}"
pgrep() {{ echo "$$"; }}
emit""",
        )
        # $7 of $300 this month.
        self.assertRegex(data["text"], r" 2% / ")
        tooltip = re.sub("<[^>]*>", "", data["tooltip"])
        self.assertIn("$7 of $300", tooltip)
        self.assertRegex(tooltip, r"gpt-test +\$5")

    def codex_share(self, spent, today, month=None):
        """Render the panel on local date today with spent micros in month."""
        month = month or today[:7]
        self.codex_login()
        sid = "01a1e399-0000-7000-8000-000000000001"
        self.codex_state(
            month=month, costs={sid: spent}, fetched=int(time.time()), updated=1
        )
        return self.payload(
            "codex",
            f"""printf() {{
	if [ "$1" = -v ] && [ "$3" = '%(%F)T' ]; then
		builtin printf -v "$2" %s {today}
	elif [ "$1" = -v ] && [ "$3" = '%(%Y-%m)T' ]; then
		builtin printf -v "$2" %s {month}
	else
		builtin printf "$@"
	fi
}}
emit""",
        )

    def test_codex_share_accumulates_over_the_month(self):
        # 2026-06 has 22 working days, the 15th is the 11th of them. The ten
        # before allow $136.36, so $36.36 spent leaves $100 or 733% ahead.
        data = self.codex_share(36363636, "2026-06-15")
        self.assertRegex(data["text"], r"#50fa7b'>-733%</span>$")
        tooltip = re.sub("<[^>]*>", "", data["tooltip"])
        self.assertIn("Day 11 of 22", tooltip)
        self.assertRegex(tooltip, r"\$13\.64 a working day +Ahead \$100")

    def test_codex_share_overdrawn(self):
        # Beyond the ten earlier shares and all of today's.
        data = self.codex_share(170000000, "2026-06-15")
        self.assertRegex(data["text"], r"#ff5555'>246%</span>$")

    def test_codex_share_overdrawn_on_day_off(self):
        # On a Sunday the ten days begun allow $136.36.
        data = self.codex_share(160000000, "2026-06-14")
        self.assertRegex(data["text"], r"#ff5555'>173%</span>$")
        self.assertRegex(
            re.sub("<[^>]*>", "", data["tooltip"]), r"(?m)Behind \$23\.64$"
        )

    def test_codex_share_before_the_billing_month_turns(self):
        # Before 09:00 on July 1st the June billing month still runs, with all
        # its 22 shares begun, so $200 spent leaves $100.
        data = self.codex_share(200000000, "2026-07-01", "2026-06")
        self.assertRegex(data["text"], r"#50fa7b'>-733%</span>$")
        tooltip = re.sub("<[^>]*>", "", data["tooltip"])
        self.assertIn("Day off", tooltip)
        self.assertRegex(tooltip, r"(?m)Ahead \$100$")

    def codex_session(self, sid, start):
        directory = self.root / "codex" / "sessions" / start.strftime("%Y/%m/%d")
        directory.mkdir(parents=True, exist_ok=True)
        path = directory / f"rollout-{start:%Y-%m-%dT%H-%M-%S}-{sid}.jsonl"
        path.write_text("")
        return path

    def codex_login(self):
        raw = json.dumps({"exp": 9999999999}).encode()
        payload = base64.urlsafe_b64encode(raw).decode().rstrip("=")
        (self.root / "codex").mkdir(exist_ok=True)
        (self.root / "codex" / "auth.json").write_text(
            json.dumps(
                {"tokens": {"access_token": f"h.{payload}.s", "account_id": "a"}}
            )
        )

    def codex_state(self, **fields):
        state = self.root / "state" / "waybar"
        state.mkdir(parents=True, exist_ok=True)
        month = datetime.now(ZoneInfo("America/Los_Angeles")).strftime("%Y-%m")
        snapshot = {
            "month": month,
            "fetched": 0,
            "updated": 0,
            "wait": 300,
            "error": "",
            "costs": {},
            "base": {},
        } | fields
        (state / "codex.json").write_text(json.dumps(snapshot))
        return state / "codex.json"

    def test_codex_restores_error_snapshot(self):
        sid = "01a1e399-0000-7000-8000-000000000001"
        now = int(time.time())
        self.codex_state(
            fetched=now, updated=now - 60, error="offline", costs={sid: 5000000}
        )
        data = self.payload("codex")
        tooltip = re.sub("<[^>]*>", "", data["tooltip"])
        self.assertIn("$5 of $300, $295 left, 1 session", tooltip)
        self.assertIn("offline", tooltip)

    def test_claude_restores_error_snapshot(self):
        state = self.runtime / "waybar"
        state.mkdir()
        now = int(time.time())
        (state / "claude.state.json").write_text(
            json.dumps(
                {
                    "limits": ["Week\u001f25\u001f0\u001ffalse"],
                    "breakdown": "",
                    "error": "offline",
                    "fetched": now,
                    "updated": now - 60,
                    "wait": 300,
                }
            )
        )
        data = self.payload("claude")
        self.assertIn("25%", data["text"])
        self.assertIn("offline", data["tooltip"])

    def test_codex_batches_sessions_and_skips_odd_names(self):
        self.codex_login()
        now = datetime.now()
        for n in range(150):
            self.codex_session(f"01a1e399-0000-7000-8000-{n:012d}", now)
        stray = self.root / "codex" / "sessions" / "rollout-renamed.jsonl"
        stray.write_text("")
        log = self.root / "batches"
        # Each request answers $1 for every session it asks about.
        self.command(
            "curl",
            f"""body=$(cat)
jq -c '.thread_ids | length' <<<"$body" >>"{log}"
jq -c '{{threads: [.thread_ids[] | {{thread_id: ., native_usage_usd_micros: 1000000}}]}}' <<<"$body"
printf 200""",
        )
        data = self.payload("codex")
        self.assertEqual(log.read_text().split(), ["100", "50"])
        self.assertIn("$150 of $300", re.sub("<[^>]*>", "", data["tooltip"]))

    def test_codex_keeps_costs_the_backend_does_not_report(self):
        self.codex_login()
        now = datetime.now()
        old = "01a1e399-0000-7000-8000-000000000001"
        new = "01a1e399-0000-7000-8000-000000000002"
        self.codex_session(old, now - timedelta(days=40))
        self.codex_session(new, now)
        self.codex_state(costs={old: 3000000}, base={old: 1000000})
        # No amount for the old session and none at all for the new one.
        self.command(
            "curl",
            f"""cat >/dev/null
printf '{{"threads":[{{"thread_id":"{old}","native_usage_usd_micros":null}}]}}\\n200'""",
        )
        tooltip = re.sub("<[^>]*>", "", self.payload("codex")["tooltip"])
        self.assertIn("$2 of $300, $298 left, 1 session, 1 without usage yet", tooltip)
        self.assertNotIn("No data", tooltip)

    def test_codex_offline_does_not_rewrite_state_every_sample(self):
        self.codex_login()
        self.codex_session("01a1e399-0000-7000-8000-000000000001", datetime.now())
        self.command("curl", "cat >/dev/null; exit 7")
        self.payload(
            "codex",
            """emit >/dev/null
before=$(stat -c '%i:%y' "$state")
emit >/dev/null
emit
[[ $(stat -c '%i:%y' "$state") == "$before" ]]""",
        )

    def test_missing_credentials_do_not_rewrite_state_every_sample(self):
        self.payload(
            "claude",
            """emit >/dev/null
before=$(stat -c '%i:%y' "$state")
emit
[[ $(stat -c '%i:%y' "$state") == "$before" ]]""",
        )

    def test_failed_update_preserves_result_and_reports_staleness(self):
        cache = self.cache / "waybar"
        cache.mkdir(parents=True)
        previous = {"text": "3", "tooltip": "Three updates", "class": "kernel"}
        (cache / "nix-updates.json").write_text(json.dumps(previous))
        data = json.loads(self.run_script("nix-updates", args=("--force",)))
        self.assertEqual(data["text"], "3")
        self.assertIn("stale", data["class"])
        self.assertIn("Updated ", data["tooltip"])
        self.assertIn("failed", data["tooltip"])
        self.assertEqual(json.loads((cache / "nix-updates.json").read_text()), previous)

    def test_update_failure_without_history_is_visible(self):
        data = json.loads(self.run_script("nix-updates", args=("--force",)))
        self.assertTrue(data["text"])
        self.assertIn("No successful check", data["tooltip"])
        self.assertIn("failed", data["tooltip"])

    def test_update_timeout_is_bounded(self):
        self.command("nix", "while true; do read -r _ || true; done")
        data = json.loads(self.run_script("nix-updates", args=("--force",)))
        self.assertIn("timed out", data["tooltip"])

    def test_update_failure_retries_then_clears_error(self):
        self.run_script("nix-updates", args=("--force",))
        self.command(
            "nix",
            """if [[ $1 == eval ]]; then echo '{"kernel":{},"base":{},"system":{},"user":{}}'; fi""",
        )
        data = json.loads(self.run_script("nix-updates", args=()))
        self.assertEqual(data, {"text": ""})
        self.assertFalse((self.cache / "waybar/nix-updates-error.json").exists())

    def test_failed_forced_refresh_does_not_expire_valid_cache(self):
        cache = self.cache / "waybar"
        cache.mkdir(parents=True)
        (cache / "nix-updates.json").write_text('{"text":"3"}')
        self.run_script("nix-updates", args=("--force",))
        self.command("nix", 'touch "$XDG_RUNTIME_DIR/unexpected-nix"; exit 1')
        for _ in range(3):
            data = json.loads(self.run_script("nix-updates", args=()))
            self.assertEqual(data["text"], "3")
            self.assertIn("failed", data["tooltip"])
        self.assertFalse((self.runtime / "unexpected-nix").exists())

    def record_online_wait(self):
        self.command("nm-online", 'echo "$*" >"$XDG_RUNTIME_DIR/nm-online"; exit 1')
        # Record whether the wait happened before the first fetch.
        self.command(
            "nix",
            'cp "$XDG_RUNTIME_DIR/nm-online" "$XDG_RUNTIME_DIR/nix" 2>/dev/null || true; exit 1',
        )

    def test_update_waits_for_network(self):
        self.record_online_wait()
        data = json.loads(self.run_script("nix-updates", args=()))
        self.assertIn("failed", data["tooltip"])
        self.assertEqual((self.runtime / "nix").read_text().strip(), "-q -t 60")

    def test_forced_update_does_not_wait_for_network(self):
        self.record_online_wait()
        self.run_script("nix-updates", args=("--force",))
        self.assertFalse((self.runtime / "nm-online").exists())

    def test_update_timeout_defaults_to_ten_minutes(self):
        self.env.pop("NIX_UPDATES_TIMEOUT")
        self.command(
            "timeout",
            'echo "$2" >"$XDG_RUNTIME_DIR/deadline"; shift 2; exec "$@"',
        )
        self.run_script("nix-updates", args=("--force",))
        self.assertEqual((self.runtime / "deadline").read_text().strip(), "600")

    def test_shared_restarts_failed_producer(self):
        # Keep actual timed waits for this supervision test.
        (self.bin / "sleep").unlink()
        producer = self.scripts / "fixture"
        producer.write_text(
            """#!/usr/bin/env bash
count_file=$XDG_RUNTIME_DIR/count
count=0
[ ! -f "$count_file" ] || read -r count <"$count_file"
count=$((count + 1))
echo "$count" >"$count_file"
if [ "$count" -gt 1 ]; then
    sleep 30 &
    echo "$!" >"$XDG_RUNTIME_DIR/child"
fi
printf '{"text":"%s"}\\n' "$count"
[ "$count" -eq 1 ] || wait
exit 1
"""
        )
        producer.chmod(0o755)
        process = subprocess.Popen(
            ["bash", str(self.scripts / "shared"), "fixture"],
            env=self.env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            start_new_session=True,
        )
        try:
            results = []
            for _ in range(2):
                self.assertTrue(select.select([process.stdout], [], [], 5)[0])
                results.append(json.loads(process.stdout.readline())["text"])
            self.assertEqual(results, ["1", "2"])
            os.killpg(process.pid, signal.SIGTERM)
            process.wait(timeout=5)
            child = (self.runtime / "child").read_text().strip()
            deadline = time.monotonic() + 2
            while time.monotonic() < deadline:
                stat = Path(f"/proc/{child}/stat")
                if not stat.exists() or stat.read_text().split()[2] == "Z":
                    break
                time.sleep(0.01)
            else:
                self.fail("Stopping the wrapper left the producer's child running")
            with (self.runtime / "waybar/fixture.lock").open("w") as lock:
                subprocess.run(
                    ["flock", "-n", str(lock.fileno())],
                    pass_fds=(lock.fileno(),),
                    check=True,
                )
        finally:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
            process.stdout.close()
            process.stderr.close()

    def test_shared_stops_producer_after_wrapper_is_killed(self):
        (self.bin / "sleep").unlink()
        producer = self.scripts / "fixture"
        producer.write_text(
            """#!/usr/bin/env bash
sleep 30 &
echo "$!" >"$XDG_RUNTIME_DIR/child"
printf '{"text":"ready"}\\n'
wait
"""
        )
        producer.chmod(0o755)
        for kill_group in (False, True):
            with self.subTest(kill_group=kill_group):
                process = subprocess.Popen(
                    ["bash", str(self.scripts / "shared"), "fixture"],
                    env=self.env,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    start_new_session=True,
                )
                child = None
                try:
                    self.assertTrue(select.select([process.stdout], [], [], 5)[0])
                    self.assertEqual(
                        json.loads(process.stdout.readline())["text"], "ready"
                    )
                    child = int((self.runtime / "child").read_text())
                    if kill_group:
                        os.killpg(process.pid, signal.SIGKILL)
                    else:
                        process.kill()
                    process.wait(timeout=5)
                    deadline = time.monotonic() + 3
                    while time.monotonic() < deadline:
                        stat = Path(f"/proc/{child}/stat")
                        if not stat.exists() or stat.read_text().split()[2] == "Z":
                            break
                        time.sleep(0.01)
                    else:
                        self.fail("SIGKILL left the producer's child running")
                finally:
                    if process.poll() is None:
                        os.killpg(process.pid, signal.SIGKILL)
                        process.wait()
                    if child:
                        try:
                            os.kill(child, signal.SIGKILL)
                        except ProcessLookupError:
                            pass
                    process.stdout.close()
                    process.stderr.close()


if __name__ == "__main__":
    unittest.main()
