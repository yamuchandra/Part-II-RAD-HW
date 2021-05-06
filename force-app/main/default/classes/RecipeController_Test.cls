@isTest
public with sharing class RecipeController_Test {
    public RecipeController_Test() {

    }
    @TestSetup
    static void prepareData(){
        //Create Recipe (with Insert) 
        Recipe__c rec = new Recipe__c();
        rec.Name = 'Chapathi';
        rec.Active_Time__c = 30;
        rec.Active_Time_Units__c = 'Minutes';
        rec.Description__c = 'Main Dish';
        rec.Servings__c = 5;
        insert rec;  
        
        List<Ingredient__c> ing = new List<Ingredient__c>();
        Ingredient__c i1 = new Ingredient__c();
        i1.Name = 'Wheat Flour';
        i1.Measurement__c = 4;
        i1.Measurement_Type__c = 'Cups';
        i1.Recipe__c = rec.id;
        ing.add(i1);

        Ingredient__c i2 = new Ingredient__c();
        i2.Name = 'Water';
        i2.Measurement__c = 1.5;
        i2.Measurement_Type__c = 'Cups';
        i2.Recipe__c = rec.id;
        ing.add(i2);

        Ingredient__c i3 = new Ingredient__c();
        i3.Name = 'Salt';
        i3.Measurement__c = 1;
        i3.Measurement_Type__c = 'Tsp';
        i3.Recipe__c = rec.id;
        ing.add(i3);

        
        insert ing;
    }

    @isTest
    static void addIngredientTestWOneRecipe() {

        //Query recipe from Test Setup mathod 
        Recipe__c rec = [SELECT Id,Name FROM Recipe__c WHERE Name = 'Chapathi' LIMIT 1];       

        //Create Ingredient (without insert)
        Ingredient__c ing = new Ingredient__c();
        String Name = 'Wheat Flour';
        Integer Measurement = 2;
        String Measurement_Type = 'Cups';
        String RecipeId = rec.id;

        Test.startTest();
            RecipeController.addIngredient(Name, Measurement, Measurement_Type, RecipeId);
        Test.stopTest();

        Ingredient__c afterAddingIngr = [SELECT Name,Measurement__c, Measurement_Type__c FROM Ingredient__c WHERE Recipe__r.id = :rec.id];

        System.assertEquals('Wheat Flour',afterAddingIngr.Name,'Name of Ingredient matching.');
        System.assertEquals(2,afterAddingIngr.Measurement__c ,'Measurement quantity of Ingredient matching.');
        System.assertEquals('Cups',afterAddingIngr.Measurement_Type__c ,'Measurement Type of Ingredient matching.');
    } 


    //  create a test Recipe obect in memory, then call the create() method and validate that a corresponding SObject was created
    // Test for 'Generate Grocery List' method
    @isTest
    static void generateGroceryListTestSingle() { 

        //Query Test Setup Method 
        //Ingredient list is created in local machine.
        Recipe__c recipe = [SELECT Id,Name FROM Recipe__c WHERE Name = 'Chapathi'];
        List<Ingredient__c> ings = [SELECT Name, Measurement__c, Measurement_Type__c  
                                    FROM Ingredient__c 
                                    WHERE Recipe__r.Name = 'Chapathi'];
                                    
        Test.startTest();
        list<Ingredient__c> generateGroceryList = RecipeController.generateGroceryList(recipe.id);
        Test.stopTest();

        Integer Count = 0;

        for(Ingredient__c i : generateGroceryList){

            System.assertEquals(i.Name,ings.get(Count).Name,'Ingredient Names Match');
            System.assertEquals(i.Measurement__c,ings.get(Count).Measurement__c,'Measurement Quantity Matches');
            System.assertEquals(i.Measurement_Type__c,ings.get(Count).Measurement_Type__c,'Measurement Type too Matches');
            
            
            Count++;
        }
    }

    

    @isTest
    static void scaleRecipeForServingsTest() {

        //Query Recipe Id from Test Setup Method

        Recipe__c recipe = [SELECT Id,Name,Servings__c FROM Recipe__c WHERE Name = 'Chapathi'];
        

        List<Ingredient__c> actualIngrs = [SELECT Id,Name,Measurement__c,Measurement_Type__c,Recipe__r.Servings__c,Recipe__r.id 
                                           FROM Ingredient__c WHERE Recipe__r.Name = 'Chapathi'];

        Test.startTest();
            List<Ingredient__c> scaledIngrs = RecipeController.scaleRecipeForServings(recipe.Id,10);
        Test.stopTest();

        Integer Count = 0;

        for(Ingredient__c i : scaledIngrs){

            System.assertEquals(i.Measurement__c,actualIngrs.get(Count).Measurement__c*(10/actualIngrs.get(Count).Recipe__r.Servings__c),'Measurements Scaled properly');
            System.debug('i.Measurement'+i.Measurement__c); //Scaled Measurement
            System.debug('i.Measurement'+actualIngrs.get(Count).Measurement__c); //Actual Measurement
            System.debug('i.Measurement'+actualIngrs.get(Count).Recipe__r.Servings__c); //Actual Recipe Servings

            Count++;
        }
    }

}
