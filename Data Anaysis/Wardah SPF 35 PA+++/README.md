# WARDAH SPF 35 PA+++
is product which widely used in Indonesia but unfortunately have a low score reviews on big online product review platform, femaledaily.com
![gsearch](gsearch.png)

so with this understanding, I'm curios on why this product has so many user yet having a low score reviews which all process on codes are in [scrape_analysis_wardah.ipynb](https://github.com/jay76-a11y/Data_Science_101/blob/main/Data%20Anaysis/Wardah%20SPF%2035%20PA%2B%2B%2B/scrape_analysis_wardah.ipynb "Named link title")

# Data Scraping
Data scraping simply done using the BeautifulSoup to gather all reviews as down below

```
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

