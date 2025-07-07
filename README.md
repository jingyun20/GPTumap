# compareUMAP: Visual comparison of UMAP plots using GPT-4o
====

## Installation 

To install the latest version of `compareUMAP` from GitHub, run the following commands in R:

```{r eval = FALSE}
install.packages("httr")
install.packages("jsonlite")
install.packages("base64enc")
remotes::install_github("jingyun20/GPTumap")
```

##  🚀 Quick start

```{r eval = FALSE}
# Assign your OpenAI API key
Sys.setenv(OPENAI_API_KEY = 'your_openai_API_key')

# Load the package
library(compareUMAP)

# Compare two UMAP images (PNG format)
res <- compare_umap("path/to/umap1.png", "path/to/umap2.png")

# View result
print(res$result)      # Returns: 1 or 2
print(res$raw_reply)   # Full GPT reply
```

### ⚠️ Warning: Do NOT share your API key publicly or upload it to GitHub.

## Contact

Authors: Jingyun Liu (jingyun.liu2@duke.edu), Zhicheng Ji (zhicheng.ji@duke.edu).


