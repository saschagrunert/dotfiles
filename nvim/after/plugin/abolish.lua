-- Spelling corrections via vim-abolish
-- Loaded after plugins so :Abolish command is available
if vim.fn.exists(":Abolish") == 0 then
  return
end

local abbreviations = {
  { "exlude", "exclude" },
  { "retrun", "return" },
  { "pritn", "print" },
  { "teh", "the" },
  { "liek", "like" },
  { "liekwise", "likewise" },
  { "moer", "more" },
  { "lenght", "length" },
  { "afterword{,s}", "afterward{}" },
  { "anomol{y,ies}", "anomal{}" },
  { "austrail{a,an,ia,ian}", "austral{ia,ian}" },
  { "cal{a,e}nder{,s}", "cal{e}ndar{}" },
  { "{c,m}arraige{,s}", "{}arriage{}" },
  { "{,in}consistan{cy,cies,t,tly}", "{}consisten{}" },
  { "delimeter{,s}", "delimiter{}" },
  { "{,non}existan{ce,t}", "{}existen{}" },
  { "despara{te,tely,tion}", "despera{}" },
  { "d{e,i}screp{e,a}nc{y,ies}", "d{i}screp{a}nc{}" },
  { "euphamis{m,ms,tic,tically}", "euphemis{}" },
  { "hense", "hence" },
  { "{,re}impliment{,s,ing,ed,ation}", "{}implement{}" },
  { "improvment{,s}", "improvement{}" },
  { "inherant{,ly}", "inherent{}" },
  { "lastest", "latest" },
  { "{les,compar,compari}sion{,s}", "{les,compari,compari}son{}" },
  { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" },
  { "{,un}orgin{,al}", "{}origin{}" },
  { "persistan{ce,t,tly}", "persisten{}" },
  { "referesh{,es}", "refresh{}" },
  { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" },
  { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" },
  { "reproducable", "reproducible" },
  { "resouce{,s}", "resource{}" },
  { "restraunt{,s}", "restaurant{}" },
  { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" },
  { "segument{,s,ed,ation}", "segment{}" },
  { "Tqbf", "The quick brown fox jumps over the lazy dog." },
  { "Lipsum", "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." },
}

for _, pair in ipairs(abbreviations) do
  vim.cmd("Abolish " .. pair[1] .. " " .. pair[2])
end
