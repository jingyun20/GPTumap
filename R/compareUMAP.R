#' Compare Two UMAP Images Using GPT-4o
#'
#' @param img1_path Path to the first image (PNG)
#' @param img2_path Path to the second image (PNG)
#' @param api_key Your OpenAI API key
#'
#' @return A list with `result` (1 or 2) and the full GPT reply
#' @export
#'
#' @import httr jsonlite base64enc
compare_umap <- function(img1_path, img2_path, api_key) {
  if (!file.exists(img1_path) || !file.exists(img2_path)) {
    stop("One or both image paths are invalid.")
  }

  img1_base64 <- base64enc::base64encode(img1_path)
  img2_base64 <- base64enc::base64encode(img2_path)

  img1_url <- paste0("data:image/png;base64,", img1_base64)
  img2_url <- paste0("data:image/png;base64,", img2_base64)

  body <- list(
    model = "gpt-4o",
    messages = list(
      list(
        role = "user",
        content = list(
          list(
            type = "text",
            text = paste(
              "You will be shown two UMAP plots. Please carefully examine both.",
              "Image 1 is labeled '1', and Image 2 is labeled '2'.",
              "Based on visual accuracy (cluster separation, boundary clarity, etc.), which one is better?",
              "Please respond with only: 1 or 2."
            )
          ),
          list(type = "image_url", image_url = list(url = img1_url)),
          list(type = "image_url", image_url = list(url = img2_url))
        )
      )
    )
  )

  res <- httr::POST(
    url = "https://api.openai.com/v1/chat/completions",
    httr::add_headers(
      Authorization = paste("Bearer", api_key),
      `Content-Type` = "application/json"
    ),
    body = jsonlite::toJSON(body, auto_unbox = TRUE)
  )

  result <- httr::content(res, as = "parsed", encoding = "UTF-8")

  if (!is.null(result$error)) {
    stop(paste("OpenAI error:", result$error$message))
  }

  reply <- result$choices[[1]]$message$content
  decision <- if (grepl("\\b1\\b", reply)) 1 else if (grepl("\\b2\\b", reply)) 2 else NA
  return(list(result = decision, raw_reply = reply))
}
