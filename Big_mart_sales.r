#Reading the datasets.
train_data = read.csv("Train.csv",na.strings = c("","NA"))
test_data = read.csv("Test.csv",na.strings = c("","NA"))

str(train_data) # checking the type of datatype
summary(train_data) # checking full data summary
colSums(is.na(train_data)) # checking the missing values in train data
colSums(is.na(test_data)) #  checking the missing values in test data


train_data = train_data[-1] # removing Identifier column in train data
test_data = test_data[-1] # removing identifier column in test data

dim(train_data) # checking how many rows and columns in R

#imputing with mean.
#For train data
mean_for_weight = mean(train_data$Item_Weight[!is.na(train_data$Item_Weight)])
train_data$Item_Weight[is.na(train_data$Item_Weight)] = mean_for_weight

#For test data
mean_for_weight = mean(test_data$Item_Weight[!is.na(test_data$Item_Weight)])
test_data$Item_Weight[is.na(test_data$Item_Weight)] = mean_for_weight


#imputing missing value using KNN imputatin for outlet size
#install.packages("VIM")
library(VIM)
missing_impute = kNN(train_data,variable = "Outlet_Size",k = 6)
View(missing_impute)
missing_impute = missing_impute[-12]
train_data = missing_impute
View(train_data)

# KNN imputation for test data
library(VIM)
missing_impute_test = kNN(test_data,variable = "Outlet_Size",k = 6)
View(missing_impute_test)
missing_impute_test = missing_impute_test[-11]
test_data = missing_impute_test
View(test_data)

#Exploratory data analysis
#Univariate Analysis
#For categorical  variables,
cont_var = train_data[,c(2,4,6,8,12)]
cat_var = train_data[,c(1,3,5,7,9,10,11)]

names(cat_var)
#checking unique values in each attribute
apply(cat_var,2,function(x){length(unique(x))})  
#for cat ITEM_fat_content
table(cat_var$Item_Fat_Content)
prop.table(table(cat_var$Item_Fat_Content))

#for cat var Item_type
sort(table(cat_var$Item_Type),decreasing = TRUE)
sort(prop.table(table(cat_var$Item_Type)),decreasing = TRUE)

#for cat_var  Outlet_Identifier
sort(prop.table(table(cat_var$Outlet_Identifier)),decreasing = TRUE)
sort(table(cat_var$Outlet_Identifier),decreasing = TRUE)

#for cat_var Outlet_size
table(cat_var$Outlet_Size)
prop.table(table(cat_var$Outlet_Size))

#for cat_var Outlet_Location_Type
prop.table(table(cat_var$Outlet_Location_Type))

# for cat_var Outlet_type
prop.table(table(cat_var$Outlet_Type))

#For continuous variable
summary(cont_var)


# converting the fat_content with variable transformation.
library(car)
train_data$Item_Fat_Content = recode(train_data$Item_Fat_Content,"c('LF','low fat','reg')='Others'")
unique(train_data$Item_Fat_Content)
View(train_data)
unique(test_data$Item_Fat_Content)

library(car)
test_data$Item_Fat_Content = recode(test_data$Item_Fat_Content,"c('LF','low fat','reg')='Others'")
unique(test_data$Item_Fat_Content)
View(test_data)

#data visualization for outlier treatment.
#continous variable
 library(ggplot2)
ggplot(train_data,aes(Item_Identifier,Item_Weight))+geom_jitter()
ggplot(train_data,aes(Item_Identifier,Item_Visibility))+geom_jitter()
ggplot(train_data,aes(Item_Identifier,Item_MRP))+geom_jitter()
# library(Boruta)
# set.seed(123)
# boruta.train = Boruta(Item_Outlet_Sales ~.,data = train_data, doTrace = 1)
# print(boruta.train)

#data preprocessing.
names(cat_var)

#converting the Item_Fat_content to numerical variable.
unique(train_data$Item_Type)
train_data$Item_Fat_Content = factor(train_data$Item_Fat_Content,levels = c("Low Fat","Others","Regular"),labels = c(1,2,3))

train_data$Item_Type = factor(train_data$Item_Type,levels = c('Dairy','Soft Drinks','Meat','Fruits and Vegetables','Household','Baking Goods','Snack Foods','Frozen Foods','Breakfast','Health and Hygiene','Hard Drinks','Canned','Breads','Starchy Foods','Others','Seafood'),
                                      labels = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16))
unique(train_data$Outlet_Identifier)
train_data$Outlet_Identifier = factor(train_data$Outlet_Identifier,levels = c('OUT049','OUT018','OUT010','OUT013','OUT027','OUT045','OUT017','OUT046','OUT035','OUT019'),
                                      labels = c(1,2,3,4,5,6,7,8,9,10))

unique(train_data$Outlet_Size)
train_data$Outlet_Size = factor(train_data$Outlet_Size,levels = c('High','Medium','Small'),
                                labels = c(1,2,3))

unique(train_data$Outlet_Location_Type)
train_data$Outlet_Location_Type = factor(train_data$Outlet_Location_Type,levels = c('Tier 1','Tier 2','Tier 3'),
                                         labels = c(1,2,3))
unique(train_data$Outlet_Type)
train_data$Outlet_Type = factor(train_data$Outlet_Type,levels = c('Supermarket Type1','Supermarket Type2','Grocery Store','Supermarket Type3'),
                                labels = c(1,2,3,4))

View(train_data)

#Encoding for test data
unique(test_data$Item_Type)
test_data$Item_Fat_Content = factor(test_data$Item_Fat_Content,levels = c("Low Fat","Others","Regular"),labels = c(1,2,3))

test_data$Item_Type = factor(test_data$Item_Type,levels = c('Dairy','Soft Drinks','Meat','Fruits and Vegetables','Household','Baking Goods','Snack Foods','Frozen Foods','Breakfast','Health and Hygiene','Hard Drinks','Canned','Breads','Starchy Foods','Others','Seafood'),
                              labels = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16))
unique(test_data$Outlet_Identifier)
test_data$Outlet_Identifier = factor(test_data$Outlet_Identifier,levels = c('OUT049','OUT018','OUT010','OUT013','OUT027','OUT045','OUT017','OUT046','OUT035','OUT019'),
                                      labels = c(1,2,3,4,5,6,7,8,9,10))

unique(test_data$Outlet_Size)
test_data$Outlet_Size = factor(test_data$Outlet_Size,levels = c('High','Medium','Small'),
                                labels = c(1,2,3))

unique(test_data$Outlet_Location_Type)
test_data$Outlet_Location_Type = factor(test_data$Outlet_Location_Type,levels = c('Tier 1','Tier 2','Tier 3'),
                                         labels = c(1,2,3))
unique(test_data$Outlet_Type)
test_data$Outlet_Type = factor(test_data$Outlet_Type,levels = c('Supermarket Type1','Supermarket Type2','Grocery Store','Supermarket Type3'),
                                labels = c(1,2,3,4))



#Scaling the data
str(train_data)
str(test_data)
library(varhandle)
train_data = unfactor(train_data)
test_data = unfactor(test_data)
train_data[-11] = scale(train_data[-11])
test_data = scale(test_data)

View(test_data)
View(train_data)


# Modelling the data and testing hypothesis.
model = lm(formula = Item_Outlet_Sales ~ .,data = train_data)
summary(model)
View(train_data)


test_data = as.data.frame(test_data)

y_pred = predict(model, newdata = test_data)
y_pred
RSS = c(crossprod(model$residuals))
MSE = RSS/length(model$residuals)
RMSE = sqrt(MSE)
RMSE

#With xgboost
library(xgboost)
regressor = xgboost(data = as.matrix(train_data[-11]), label = train_data$Item_Outlet_Sales, nrounds = 10)


# Predicting the Test set results
y_pred = predict(regressor, newdata = as.matrix(test_data[-11]))
#y_pred = (y_pred >= 0.5)
y_pred
write.csv(y_pred,"G:/Study/R/Online_datasets/Analytics_vidhya_datasets/Big_mart_sales/pred_with_xgboost.csv")


