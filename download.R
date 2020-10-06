
library("furrr")
plan(multisession, workers = 15)

dat <- readr::read_csv("download_index.csv", col_names = FALSE)
colnames(dat) = c("url","dest")
filename = fs::path_file(dat[["url"]])
fs::dir_create(dat[["dest"]])
lol = list(url = dat[["url"]],
           destfile = fs::path(dat[["dest"]], filename))
print(lol)
future_pmap(lol, .f = curl::curl_download)
