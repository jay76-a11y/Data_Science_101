# WARDAH SPF 35 PA+++
is product which widely used in Indonesia but unfortunately have a low score reviews on big online product review platform, femaledaily.com
![gsearch](gsearch.png)

so with this understanding, I'm curios on why this product has so many user yet having a low score reviews which all process on codes are in [scrape_analysis_wardah.ipynb](https://github.com/jay76-a11y/Data_Science_101/blob/main/Data%20Anaysis/Wardah%20SPF%2035%20PA%2B%2B%2B/scrape_analysis_wardah.ipynb "Named link title")

# Data Scraping
Data scraping simply done using the BeautifulSoup to gather all reviews as down below

```python
url = "https://reviews.femaledaily.com/products/moisturizer/sun-protection-44/wardah/sun-block-spf-33?cat=&cat_id=0&age_range=&skin_type=&skin_tone=&skin_undertone=&hair_texture=&hair_type=&order=newest&page=1"
headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/12.0'}
r = requests.get(url, headers= headers)
soup = BeautifulSoup(r.text, 'html.parser')
prod_detail = soup.find('div',id_="id-product-details")
class_1 = prod_detail.find('div', class_="jsx-2016320139 jsx-2462230538 d-flex review-content-container")
review_col = class_1.find('div', id="review-col")
list_reviews = review_col.find('div', class_="jsx-2016320139 jsx-2462230538 list-reviews") 
review = str(list_reviews.find('p', class_="text-content"))
```

upon the analysis, it will be hard if I don't know the intention towards the reviews, which why later I will divide the reviews with each emotion extracted using huggingface pretrained model. But before jumps into that, we will look at the combined reviews's wordcloud as down below
![all_wordcloud](all_wordcloud.png)

# Emotions
The emotion got extracted using huggingface model that then will show the motion each review has
```python
from transformers import pipeline

pipe = pipeline("text-classification", model="akahana/indonesia-emotion-roberta", device=0)
```

# Result
After dividing into each emotions, now I can understand why this product is widely used yet having a low review score which the cons I listed below
- People don't like about the sticky texture of the product
- People don't like about the white cast (white imprint in the skin after application)
- People talks about the oily which may lead to this product is not suitable for people with oily skintype OR the skin texture texture after the application

