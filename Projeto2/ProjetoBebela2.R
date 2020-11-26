library(httr)

pags <- (1:13)

url <- url2 <- "https://www.jardineiro.net/plantas-de-a-a-z-por-nome-cientifico/"

pag <- GET(url = url,
    query = list(
      page = 2
    ))

index <- pag %>% read_html() %>% xml_find_all("//*[@target='_self']") %>% xml_attr("href")


textoTabela <- index[[1]] %>% read_html() %>% xml_find_all("//*[(@id = 'custom_type_fields')]//li") %>% html_text()

# index[[1]] %>% read_html() %>% html_nodes("#custom_type_fields li") %>% html_text()

if (any(!is.na(str_extract(a, "Sinonímia:")))) {
  a <- a[-2]
}

tabela <- as.data.frame(textoTabela) %>%
  tidyr::separate(textoTabela, into = c("names","dados"), sep = ": ", extra = "merge") %>%
  dplyr::select(dados) %>%
  t() %>%
  as.data.frame()


names(tabela) <- names(tabela)
tabela <- rbind(tabela, tabela2)

