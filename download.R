
library("furrr")

if (interactive()){
  args = 3
} else {
  args = commandArgs(trailingOnly = TRUE)
}

plan(multisession, workers = args[1])

dat <- readr::read_csv("download_index.csv", col_names = FALSE)
colnames(dat) = c("url","dest")
filename = fs::path_file(dat[["url"]])
dest_file = fs::path(dat[["dest"]], filename)

mask = !fs::file_exists(dest_file)

dat = dat[mask,]
dest_file = dest_file[mask]

if(length(dest_file) == 0){
  warning("no files to download")
  q(save = "no",status = 0)
}

fs::dir_create(dat[["dest"]])
lol = list(url = dat[["url"]],
           destfile = dest_file)
print(lol)
future_pmap(lol, .f = curl::curl_download)
