import pandas as pd
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.metrics.pairwise import cosine_similarity
import pickle as pkl


# Retriving the neccery datas for prediction
            

class Recommendator:

    def __init__(self , fileName):
        
        with open(fileName, "rb") as f:

            self.pickleData = pkl.load(f)

        self.unique_combinations =  self.pickleData["unique_combinations"]
        self.cossim = self.pickleData["cossim"]
        self.unique_features = self.pickleData["unique_features"]
        self.clgDict = self.pickleData["clgDict"]
        self.comMappings = self.pickleData["comMappings"]
        self.braMappings = self.pickleData["braMappings"]
        self.availKeys = self.pickleData["availKeys"]


    #if the key did not in our list choosing approriate key
    def getKey(self , arr):
    
        m , c , b = arr
        keys =  self.unique_combinations[(self.unique_combinations["COMMUNITY"] == c) &
                    (self.unique_combinations["BRANCH CODE"] == b) & 
                    (self.unique_combinations["AGGREGATEMARK"] <= m)][["AGGREGATEMARK" ,"COMMUNITY" , "BRANCH CODE"]].values
    
        if(len(keys) > 0):
            return tuple(keys[0])
        
        keys =  self.unique_combinations[(self.unique_combinations["COMMUNITY"] == c) &
            (self.unique_combinations["BRANCH CODE"] == b) 
            ][["AGGREGATEMARK" ,"COMMUNITY" , "BRANCH CODE"]].values
        
        if(len(keys) > 0):
            return tuple(keys[0])
        
        return (200.0 ,4, 26)
        





    # Getting the similar marks using cossim
    def getSimilars(self, arr , cos_sim):


        if(isinstance(arr[1] , str)):
            arr[1] = self.comMappings[arr[1]]

        if(isinstance(arr[2] , str)):
            arr[2] = self.braMappings[arr[2]]
        
            

        arr = (float(arr[0]) , arr[1] , arr[2])

        if(arr not in self.availKeys):
            arr = self.getKey(arr)

        print(arr)

        index = self.unique_features.loc[tuple(arr)]["indices"]

        similars = list(enumerate(cos_sim[index]))

        similars = sorted(similars , key = lambda x :  x[1] , reverse = True)

        similars = [i for i,j in similars]


        similar_marks = self.unique_combinations.iloc[similars]

        return similar_marks[ (similar_marks["COMMUNITY"] == arr[1]) & (similar_marks["BRANCH CODE"] == arr[2])]
    

    # Getting the colleges of the marks from the similar marks
    def getColleges(self , arr):

        
        cos_sim = self.cossim

        similar_marks = self.getSimilars(arr, cos_sim)

        unique_clgs = list()

        
        for i in range(len(similar_marks)):
        
            index = similar_marks.iloc[i].values

            index = tuple(index)


            for clg in self.clgDict[index]:
        
        
                if clg not in unique_clgs:
                    unique_clgs.append(clg)

        return unique_clgs[:10]

    



if __name__ == "__main__":
    
    #similars = getSimilars([200,4,0])
    #print(similars)

    recommendator = Recommendator("pickleData")
    recommended_clgs = recommendator.getColleges([200,0,0])
    print(recommended_clgs)

# python -m uvicorn server:app --host localhost --port 4000 --reload