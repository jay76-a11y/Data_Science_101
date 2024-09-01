from fastapi import FastAPI
from fastapi.responses import JSONResponse
import xgboost as xgb
import torch
import torch.nn as nn
import torchvision
from torchvision.transforms import functional as F
from torchvision import models, transforms
import torchvision.transforms as transforms
import pandas as pd
from typing import List
from PIL import Image
from sklearn.preprocessing import OneHotEncoder
from sklearn.base import TransformerMixin
import os
import numpy as np

import warnings
warnings.filterwarnings('ignore')


undersampled_data = pd.read_csv("datasets/ISIC/undersampled_data.csv")
labels = undersampled_data['target'].tolist()

##  model for feature extraction
device = torch.device("cuda", 0)
googlenet = (models.googlenet(pretrained=True)).to(device)
googlenet.fc = torch.nn.Linear(1024, len(set(labels))).to(device)
class FeatureExtractor(nn.Module):
    def __init__(self, original_model):
        super(FeatureExtractor, self).__init__()
        self.features = nn.Sequential(*list(original_model.children())[:-1])  # Exclude the final layer

    def forward(self, x):
        x = self.features(x)
        return x
model_FE = FeatureExtractor(googlenet).to(device)
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])



##  model for prediction
model_path = "models/ISIC_model_2024_v2.json"
xgb_mod = xgb.Booster()
xgb_mod.load_model(model_path)

#   feature used in model
features_list = [
    "age_approx", "clin_size_long_diam_mm", "tbp_lv_A", "tbp_lv_Aext", "tbp_lv_B", "tbp_lv_Bext", "tbp_lv_H",
    "tbp_lv_Hext", "tbp_lv_L", "tbp_lv_Lext", "tbp_lv_areaMM2", "tbp_lv_area_perim_ratio", "tbp_lv_color_std_mean",
    "tbp_lv_deltaA", "tbp_lv_deltaB", "tbp_lv_deltaL", "tbp_lv_deltaLB", "tbp_lv_deltaLBnorm", "tbp_lv_minorAxisMM",
    "tbp_lv_nevi_confidence", "tbp_lv_perimeterMM", "tbp_lv_radial_color_std_max", "tbp_lv_stdL", "tbp_lv_stdLExt",
    "tbp_lv_symm_2axis_angle", "tbp_lv_x", "tbp_lv_y", "tbp_lv_z", "mel_thick_mm", "tbp_lv_dnn_lesion_confidence",
    "anatom_site_general_anterior torso", "anatom_site_general_head/neck", "anatom_site_general_lower extremity",
    "anatom_site_general_posterior torso", "tbp_tile_type_3D: white", "tbp_lv_location_simple_Head & Neck",
    "tbp_lv_location_simple_Right Leg", "feature_3", "feature_4", "feature_7", "feature_11", "feature_12",
    "feature_13", "feature_15", "feature_16", "feature_18", "feature_26", "feature_35", "feature_36", "feature_40",
    "feature_41", "feature_44", "feature_49", "feature_51", "feature_53", "feature_54", "feature_59", "feature_60",
    "feature_62", "feature_63", "feature_67", "feature_68", "feature_72", "feature_74", "feature_77", "feature_79",
    "feature_81", "feature_82", "feature_83", "feature_85", "feature_88", "feature_93", "feature_98", "feature_103",
    "feature_109", "feature_123", "feature_124", "feature_127", "feature_128", "feature_133", "feature_134",
    "feature_135", "feature_137", "feature_138", "feature_142", "feature_151", "feature_157", "feature_168",
    "feature_177", "feature_180", "feature_181", "feature_183", "feature_196", "feature_197", "feature_202",
    "feature_204", "feature_207", "feature_208", "feature_211", "feature_214", "feature_216", "feature_219",
    "feature_222", "feature_227", "feature_232", "feature_233", "feature_234", "feature_238", "feature_249",
    "feature_251", "feature_255", "feature_258", "feature_265", "feature_266", "feature_267", "feature_269",
    "feature_273", "feature_280", "feature_288", "feature_290", "feature_292", "feature_296", "feature_299",
    "feature_300", "feature_306", "feature_310", "feature_311", "feature_316", "feature_322", "feature_324",
    "feature_325", "feature_330", "feature_333", "feature_336", "feature_339", "feature_342", "feature_344",
    "feature_347", "feature_348", "feature_354", "feature_355", "feature_356", "feature_361", "feature_365",
    "feature_366", "feature_368", "feature_374", "feature_375", "feature_376", "feature_381", "feature_382",
    "feature_388", "feature_396", "feature_397", "feature_400", "feature_403", "feature_404", "feature_405",
    "feature_408", "feature_409", "feature_411", "feature_412", "feature_415", "feature_416", "feature_417",
    "feature_418", "feature_419", "feature_420", "feature_424", "feature_428", "feature_431", "feature_434",
    "feature_437", "feature_438", "feature_439", "feature_440", "feature_441", "feature_444", "feature_446",
    "feature_448", "feature_450", "feature_451", "feature_452", "feature_456", "feature_457", "feature_464",
    "feature_469", "feature_472", "feature_474", "feature_476", "feature_477", "feature_479", "feature_480",
    "feature_481", "feature_486", "feature_488", "feature_492", "feature_496", "feature_499", "feature_500",
    "feature_501", "feature_507", "feature_510", "feature_515", "feature_517", "feature_518", "feature_523",
    "feature_525", "feature_527", "feature_528", "feature_529", "feature_531", "feature_533", "feature_539",
    "feature_541", "feature_542", "feature_544", "feature_545", "feature_549", "feature_550", "feature_551",
    "feature_552", "feature_559", "feature_560", "feature_561", "feature_565", "feature_566", "feature_568",
    "feature_569", "feature_573", "feature_575", "feature_577", "feature_578", "feature_579", "feature_588",
    "feature_591", "feature_592", "feature_597", "feature_598", "feature_599", "feature_602", "feature_612",
    "feature_613", "feature_615", "feature_618", "feature_619", "feature_620", "feature_626", "feature_627",
    "feature_630", "feature_635", "feature_637", "feature_641", "feature_643", "feature_646", "feature_647",
    "feature_648", "feature_650", "feature_651", "feature_652", "feature_655", "feature_656", "feature_662",
    "feature_663", "feature_666", "feature_668", "feature_670", "feature_673", "feature_675", "feature_681",
    "feature_682", "feature_684", "feature_688", "feature_689", "feature_692", "feature_703", "feature_706",
    "feature_708", "feature_710", "feature_714", "feature_720", "feature_722", "feature_725", "feature_727",
    "feature_728", "feature_739", "feature_740", "feature_741", "feature_744", "feature_745", "feature_746",
    "feature_748", "feature_749", "feature_750", "feature_755", "feature_757", "feature_758", "feature_761",
    "feature_763", "feature_768", "feature_770", "feature_771", "feature_772", "feature_774", "feature_777",
    "feature_778", "feature_779", "feature_781", "feature_784", "feature_785", "feature_790", "feature_791",
    "feature_793", "feature_803", "feature_805", "feature_808", "feature_814", "feature_816", "feature_822",
    "feature_833", "feature_834", "feature_838", "feature_845", "feature_847", "feature_848", "feature_851",
    "feature_852", "feature_856", "feature_860", "feature_863", "feature_865", "feature_866", "feature_869",
    "feature_870", "feature_873", "feature_875", "feature_877", "feature_879", "feature_880", "feature_881",
    "feature_882", "feature_886", "feature_889", "feature_893", "feature_894", "feature_896", "feature_900",
    "feature_902", "feature_903", "feature_904", "feature_905", "feature_906", "feature_907", "feature_915",
    "feature_923", "feature_926", "feature_931", "feature_935", "feature_937", "feature_938", "feature_940",
    "feature_941", "feature_943", "feature_947", "feature_948", "feature_950", "feature_951", "feature_956",
    "feature_959", "feature_964", "feature_965", "feature_966", "feature_968", "feature_970", "feature_973",
    "feature_974", "feature_985", "feature_987", "feature_988", "feature_990", "feature_991", "feature_992",
    "feature_993", "feature_996", "feature_999", "feature_1004", "feature_1006", "feature_1008", "feature_1011",
    "feature_1012", "feature_1014", "feature_1015", "feature_1022"
]

## make it to be a class for future useage
sex_map = {'male':1, "female":0}
encoder = OneHotEncoder(sparse_output=False)
class DataFrameImputer(TransformerMixin):
    def fit(self, X, y=None):
        self.fill = pd.Series([X[c].value_counts().index[0]
            if X[c].dtype == np.dtype('O') else X[c].mean() for c in X],
            index=X.columns)

        return self

    def transform(self, X, y=None):
        return X.fillna(self.fill)
class dataCleaning():
    def __init__(self, df):
        self.df  = df
        self.df['mel_thick_mm'] = (self.df['mel_thick_mm'].fillna(0) ).astype(float)        
        self.sex_map = {'male':1, "female":0}
        self.df['sex'] = self.df['sex'].map(sex_map)
        self.encoder = OneHotEncoder(sparse_output=False)
        self.categorical_columns = self.df[[column for column in self.df.columns if column not in ['isic_id']]].select_dtypes(include=['object']).columns.tolist()
    
    def imputate(self):
        self.df = DataFrameImputer().fit_transform(self.df)
        
        return self.df
    
    def encode(self):
        for column in self.categorical_columns:
            df_to_encode = self.df[[column]]
            one_hot_encoded = encoder.fit_transform(df_to_encode)
            one_hot_df = pd.DataFrame(one_hot_encoded, columns=encoder.get_feature_names_out([column]))
            self.df = pd.concat([self.df, one_hot_df], axis=1).drop(columns=[column])
            
        return self.df               



#############   APPLICATION     ######################################
app = FastAPI()


    
@app.get('/')
def root():
    return{'hello.':'world'}


##  function to do the prediction
@app.get('/pred')
def prediction(path : str, data:str):
    
    data = data.split(',')
    data = [float(value.strip().strip('"')) if value.strip().strip('"').replace('.', '', 1).isdigit() else value.strip().strip('"') for value in data]
    data = [np.NaN if val == '' or val == 'NA' else val for val in data]
    
    cols = ["age_approx","sex","anatom_site_general","clin_size_long_diam_mm","image_type","tbp_tile_type","tbp_lv_A","tbp_lv_Aext","tbp_lv_B","tbp_lv_Bext",
            "tbp_lv_C","tbp_lv_Cext","tbp_lv_H","tbp_lv_Hext","tbp_lv_L","tbp_lv_Lext","tbp_lv_areaMM2","tbp_lv_area_perim_ratio","tbp_lv_color_std_mean",
            "tbp_lv_deltaA","tbp_lv_deltaB","tbp_lv_deltaL","tbp_lv_deltaLB","tbp_lv_deltaLBnorm","tbp_lv_eccentricity","tbp_lv_location","tbp_lv_location_simple",
            "tbp_lv_minorAxisMM","tbp_lv_nevi_confidence","tbp_lv_norm_border","tbp_lv_norm_color","tbp_lv_perimeterMM","tbp_lv_radial_color_std_max","tbp_lv_stdL",
            "tbp_lv_stdLExt","tbp_lv_symm_2axis","tbp_lv_symm_2axis_angle","tbp_lv_x","tbp_lv_y","tbp_lv_z","attribution","copyright_license","lesion_id","iddx_full",
            "iddx_1","iddx_2","iddx_3","iddx_4","iddx_5","mel_mitotic_index","mel_thick_mm","tbp_lv_dnn_lesion_confidence"]
    
    #   made as dataset first
    test = pd.DataFrame()
    for i, col in enumerate(cols):
        test[col] = [data[i]]
        
    excluded = ['patient_id', 'image_type', 'iddx_full', 'lesion_id', 'iddx_1', 'iddx_2', 'iddx_3', 'iddx_4', 'iddx_5', 'mel_mitotic_index', 'attribution', 'copyright_license', 'tbp_lv_location']
    
    new_data = dataCleaning((test[[column for column in test.columns if column not in excluded]]))
    new_data.imputate()
    new_data.encode()
    test = new_data.df
    
    
    #   feature extraction
    features_dict = {}
    img = Image.open(path)
    img_t = preprocess(img)
    batch_t = torch.unsqueeze(img_t, 0).to(device)
    features = model_FE(batch_t)
    listed_feature = features.detach().cpu().numpy().tolist()
    for j, feat in enumerate(listed_feature[0]):
        if f'feature_{j}' in features_dict:
            features_dict[f'feature_{j}'].append(feat[0][0])
        else:
            features_dict[f'feature_{j}'] = [feat[0][0]]
    
    for feature in features_dict:
        test[feature] = features_dict[feature]
    
    for feature in features_list:
        if feature not in test.columns:
            test[feature] = [0]
        
    test = test[features_list]
    

    result = xgb_mod.predict(xgb.DMatrix(test.values.reshape(1,-1), enable_categorical=True, feature_names=features_list))

    return{'prediction':str(result[0])}
    
    
    

