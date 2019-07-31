library(rcoreoa)
library(RCurl)
CORE_KEY= "KN1ys59I8uUDxnFOzmJptr36jSoBLRvg"

QUERY = data.frame("all_of_the_words" = "hacker",
                   "find_those_words" = "b",
                   "language" = "pt",
                   "year_from" = 2018,
                   "year_to" = 2019)

RES = data.frame(ID=character(),
                 Author_1st=as.character(),
                 Title=as.character(), 
                 Year=as.character(), 
                 Description=as.character(), 
                 Download_link=as.character())

last = round(core_advanced_search(query = QUERY, key = CORE_KEY)$totalHits/100)

for (pp in 1:last){
  res = core_advanced_search(query = QUERY, 
                             key = CORE_KEY,
                             page = pp,
                             limit = 100)
  
  RES = rbind(RES,
              data.frame(ID = res$data$`_source`$id,
                         Author_1st = unlist(lapply(res$data$`_source`$authors, function(x) x[1])),
                         Title = res$data$`_source`$title, 
                         Year = res$data$`_source`$year, 
                         Description = unlist(res$data$`_source`$description), 
                         Download_link = res$data$`_source`$downloadUrl)
  )
}

who = which(RES$Download_link != "" & RES$Description != "")
RES = RES[who,]

write.csv2(RES,"Leprosy Articles.csv", row.names = FALSE)
RES = read.csv2("Leprosy Articles.csv")

for (i in 1:nrow(RES)){
    my_destfile = paste("C:/Users/Desenvolvedor/Desktop/Artigos",
                        RES$Author_1st[i],
                        " (",RES$Year[i],").pdf", sep="")
  my_url = as.character(RES$Download_link[i])
  if (url.exists(my_url)){
    download.file(url = my_url, 
                  destfile = my_destfile,
                  mode = "wb") 
  }
}

