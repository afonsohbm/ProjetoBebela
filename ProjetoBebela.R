library("rvest")

url <- "https://www.jardineiro.net/plantas-de-a-a-z-por-nome-cientifico"

indexPlantas <- read_html(url) %>% html_nodes(".pt-cv-ifield") #Pega os infos das plantas na URL



#Download das imagens
linkDownload <- read_html(url) %>% html_nodes(".cvplazy")

x <- xml_attrs(linkDownload[[1]])[["data-cvpset"]]

strsplit()

download.file('https://www.jardineiro.net/wp-content/uploads/2011/05/abelia_x_grandiflora-175x175.jpg', 
              "y.jpg", mode = 'wb')

y <- readJPEG("y.jpg",native=TRUE)
plot(0:1,0:1,type="n",ann=FALSE,axes=FALSE)
rasterImage(y,0,0,1,1)

xml_attrs(linkDownload[[1]])[["alt"]]



tabela <- data.frame(nomeCientifico = c(),
                     nomePopular = c(),
                     familia = c(),
                     categoria = c(),
                     clima = c(),
                     origem = c(),
                     altura = c(),
                     luminosidade = c(),
                     cicloDeVida = c())

nomes <- c("nomeCientifico", "nomePopular",
           "familia",
           "categoria",
           "clima",
           "origem",
           "altura",
           "luminosidade",
           "cicloDeVida")



#Percorrendo as pags e pegando as infos:

for (j in 2:13) {

  url2 <- "https://www.jardineiro.net/plantas-de-a-a-z-por-nome-cientifico/?_page="
  url2 <- paste0(url2,j)
  
  indexPlantas <- read_html(url2) %>% html_nodes(".pt-cv-ifield") #Pega os infos das plantas na URL
  
  for (i in 1:length(indexPlantas)) {
    link <- xml_attrs(xml_child(indexPlantas[[i]], 2))[["href"]]
  
    a <- read_html(link) %>% html_nodes("#custom_type_fields li") %>% html_text()
    
    if (any(!is.na(str_extract(a, "Sinonímia:")))) {
      a <- a[-2]
    }
    
    b <- as.data.frame(a) %>% 
      tidyr::separate(a, into = c("b","c"), sep = " ")
    tabela2 <- as.data.frame(t(b$c))
    names(tabela2) <- names(tabela)
    tabela <- rbind(tabela, tabela2)
    
  }  
  
  
  
}

