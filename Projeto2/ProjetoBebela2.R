library(httr)
library(magrittr)

#pags <- (1:13)

url <- "https://www.jardineiro.net/plantas-de-a-a-z-por-nome-cientifico/"

pag <- httr::GET(url = url)

#pega o link da página de cada planta
index <- pag %>% xml2::read_html() %>% xml2::xml_find_all("//*[@target='_self']") %>% xml2::xml_attr("href")

caminho <- "Projeto2/raw/"

if(!fs::dir_exists(caminho)) fs::dir_create(caminho)


#baixa a página de cada planta
index %>% 
  purrr::map(~GET(.x, 
                  httr::write_disk(paste0(caminho, 
                                          which(index == .x)), 
                                   TRUE)))


#extração e arrumação dos dados de cada planta
extraiDados <- function(path){
  vetor <- path %>% xml2::read_html() %>% xml2::xml_find_all("//*[(@id = 'custom_type_fields')]//li") %>% rvest::html_text()
  if (any(!is.na(str_extract(vetor, "Sinonímia:")))) {
    vetor <- vetor[-2]
  }
  
  vetor <- as.data.frame(vetor) %>% 
    tidyr::separate(col = vetor, into = c("names","dados"), sep = ": ", extra = "merge") %>% 
    tidyr::pivot_wider(names_from = names, values_from=dados)
  
  return(vetor) 
}



base <- paste0(caminho, c(1:length(fs::dir_ls(caminho)))) %>% 
  purrr::map_dfr(extraiDados)



saveRDS(base, file = "Projeto2/base.RDS")

