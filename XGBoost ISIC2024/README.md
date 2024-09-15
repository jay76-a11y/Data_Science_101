#   ISIC 2024 CHALLENGE
ISIC 2024 Challenge is a competition in Kaggle which asks the participant to develop image-based algorithms to identify histologically confirmed skin cancer cases with single-lesion crops from 3D total body photos (TBP). The image quality resembles close-up smartphone photos, which are regularly submitted for telehealth purposes.

![cover](pics/cover.png)

##  Basic Idea
Instead of completing the challenge by combining the prediction of image based model (typically CNN to classify pictures), I'm using a tree based model instead since it is proved by many papers that tree based model will always outperform NN based model on tabular data, and for this case I choose XGBoost as the base model and googlenet


##  API
API or Application Programming Interface is a set of rules and protocols that allow different software applications to communicate with each other. APIs define methods and data formats that programs use to request and exchange information.
In this project, FastAPI will be utilized to deploy the model for easier usage in the future

#   HOW TO RUN

##  preparation
first prepare the postgreSQL server and the database will be used under the file [databse.py](https://github.com/jay76-a11y/Data_Science_101/blob/main/end-to-end%20ISIC%202024/database.py "Named link title")

```
DATABASE_URL = "postgresql://postgres:maulana@localhost:5432/ISIC2024"
```

##  Initiation
First, need to run the app via terminal

```python
uvicorn ISIC_FastAPI:app --reload
```
when running this, the app will be initiated and will automatically pick the data inside the database in postgreSQL and will also do "Drop Duplicates" in the database

##  Prediction
to predict with the model, since I belive that if this got implemented the format document can't be changed as a matter of documantion, so the data processing will be done inside the API, so for calling the API, it is still needed to input all data as the original dataset, the picture, and the patient ID

```
Invoke-RestMethod -Uri 'http://127.0.0.1:8000/pred?path=pics\\ISIC_2949469.jpg&patient=0&data=85,"female","lower extremity",5.56,"TBP tile: close-up","3D: white",19.5799519935599,17.9340002805905,19.8366102116962,19.3989781342338,27.8723092828865,26.4187190968204,45.3730722322942,47.2471821988473,49.1465238259538,57.4482490114007,16.1944079564646,35.8453837945357,2.57039859591327,1.64595171296942,0.437632077462368,-8.30172518544693,8.91452179750728,6.15244915151729,0.653787188411629,"Right Leg - Lower","Right Leg",4.63459746478355,0.0023362426873063,7.63509901717087,6.9396825690451,24.0934590402615,2.0698783155492,3.15185588178021,3.02930094002448,0.457960644007156,10,271.805480957031,266.423645019531,79.9649658203125,"Memorial Sloan Kettering Cancer Center","CC-BY","","Benign","Benign","","","","","",NA,53.9182066917419' -Method Get 
```


