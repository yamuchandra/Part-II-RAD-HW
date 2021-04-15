@isTest
public class RecipeTriggerHW4Handler_TestHW5 {

/********************Week6HW 6.i)1/2 Starting ****************************************/
// Scenario: Recipe already existing in Cookbook
//Add custom exception - Do we need to add in Handler class or in Test Class?

public class MyException extends Exception{}

/********************Week6HW 6.i)1/2 Ending ******************************************/

    
    //Test Data Setup which will be ready when the class is called
    @testSetup
    static void testDataSetup(){
        List<Recipe__c> recipes = TestFactory.prepareRecipeList(4,4,false);
        List<Cookbook__c> cookbooks = TestFactory.prepareCookbookList(2,true);
        //List<Recipe_Usage__c> recUsages = TestFactory.prepareRecipeUsageList();

        List <Recipe_Usage__c> recUsagesList = new List<Recipe_Usage__c>();
           
        for (Recipe__c r : recipes){
            for (Cookbook__c cb : cookbooks){

                Recipe_Usage__c recUsage = new Recipe_Usage__c();
                recUsage.Recipe__c = r.ID;          
                recUsage.Cookbook__c = cb.Id;
                recUsagesList.add(recUsage);
            }
        }


        //List<sObject> recipes = Test.loadData(Recipe__c.SObjectType, 'recipes');
    }
 
    /*************************************************************************************************************************************
    //a.i)If a recipe is missing any key value mark it as Draft. \/
    (Name, Active_Time__c, Description__c, Active_Time_Units__c, Servings__c)
    //a.i)Create recipe with missing key values. And assert as a Draft recipe.
    **************************************************************************************************************************************/

    @isTest
    static void isDraftRecipe() {

        // Query recipe record from test data created using @testSetup method
        List<Recipe__c> recs = [SELECT Id,Name,Active_Time__c,Active_Time_Units__c,Description__c,Servings__c FROM Recipe__c LIMIT 200];

        
        Test.startTest();
            insert recs;
        Test.stopTest();

        
        List<Recipe__c> recInserted = [SELECT Id, Name, Description__c, Draft__c FROM Recipe__c WHERE Id = :recs];

        for(Recipe__c r: recInserted){
            System.assertEquals(true, r.Draft__c, 'A Recipe missing required field/s is marked as a Draft');
        }
    }

    /*************************************************************************************************************************************
    //a.i)If a recipe is poulated with all key values mark it as Non-Draft.  \/
    (Name, Active_Time__c, Description__c, Active_Time_Units__c, Servings__c)
    //a.i)Create recipe with all required key values. And assert as a Non-Draft recipe.
    **************************************************************************************************************************************/


    @isTest
    static void isNotDraftRecipe() {

        // Query recipe record from test data created using @testSetup method
        List<Recipe__c> recs = [SELECT Id,Name,Active_Time__c,Active_Time_Units__c,Description__c,Servings__c FROM Recipe__c LIMIT 200];
        List<Recipe__c> recsInserted = new List<Recipe__c>();

        for(Recipe__c r: recs){

            r.Description__c = 'Test recipe';
            r.Active_Time_Units__c = 'Hours';
            recsInserted.add(r);
        }

        Test.startTest();
            insert recsInserted;
        Test.stopTest();

        List<Recipe__c> recipesInserted = [SELECT Id, Name, Complexity__c, Description__c, Draft__c FROM Recipe__c WHERE Id = :recs];


        for(Recipe__c r: recipesInserted){
            System.assertEquals(false, r.Draft__c, 'A Recipe populated with all required fields is marked as Not Draft');
        }
    }
    
    /*****************************************************************************************************************************************************
    //a.ii)Check if a recipe is a difficult Recipe. 
    "Condition: If the recipe has an active time of an hour or more, it's difficult(HelperFunctions Class)"
    //a.ii)Create recipe with the conditions for diffilcult recipe. And assert as Difficult.
    ******************************************************************************************************************************************************/
    

    @isTest
    static void isDifficultRecipe(){

        List<Recipe__c> recs = [SELECT Id,Name,Active_Time__c,Active_Time_Units__c,Description__c,Servings__c FROM Recipe__c LIMIT 200];
        List<Recipe__c> recsInserted = new List<Recipe__c>();

        for(Recipe__c r: recs){

            r.Active_Time__c = 2;
            r.Description__c = 'Difficult recipe';
            r.Active_Time_Units__c = 'Hours';
            recsInserted.add(r);

        }

        Test.startTest();
            insert recsInserted;
        Test.stopTest();

        List<Recipe__c> recipesInserted = [SELECT Id, Name, Complexity__c, Description__c, Draft__c FROM Recipe__c WHERE Id = :recs];


        for(Recipe__c r: recipesInserted){
            System.assertEquals('Difficult', r.Complexity__c, 'Recipe has more than an hour of Active time - Difficult Recipe');
        }
        
    }

    /*****************************************************************************************************************************************************
    //a.ii)Check if a recipe is a  Moderate Recipe. 
    "Condition: If it's less than an hour but it has over 6 servings, we'll call it moderate (HelperFunctions Class)"
    //a.ii)Create recipe with the conditions for moderate recipe. And assert as Moderate.
    ******************************************************************************************************************************************************/
    

    @isTest
    static void isModerateRecipe(){

        List<Recipe__c> recs = [SELECT Id,Name,Active_Time__c,Active_Time_Units__c,Description__c,Servings__c FROM Recipe__c LIMIT 200];
        List<Recipe__c> recsInserted = new List<Recipe__c>();

        for(Recipe__c r: recs){

            r.Active_Time__c = 50;
            r.Description__c = 'Moderate recipe';
            r.Active_Time_Units__c = 'Minutes';
            r.Servings__c = 8;
            recsInserted.add(r);

        }

        Test.startTest();
            insert recsInserted;
        Test.stopTest();

        List<Recipe__c> recipesInserted = [SELECT Id, Name, Complexity__c, Description__c, Draft__c FROM Recipe__c WHERE Id = :recs];


        for(Recipe__c r: recipesInserted){
            System.assertEquals('Moderate', r.Complexity__c, 'Recipe has less than an hour & more than 6 Servings - Moderate Recipe');
        }
        
    }

    /*****************************************************************************************************************************************************
    //a.ii)Check if a recipe is a  Simple Recipe. 
    "Condition: If it's less than an hour and it has <= 6 servings, we'll call it simple (HelperFunctions Class)"
    //a.ii)Create recipe with the conditions for simple recipe. And assert as Simple.
    ******************************************************************************************************************************************************/
    

    @isTest
    static void isSimpleRecipe(){

        List<Recipe__c> recs = [SELECT Id,Name,Active_Time__c,Active_Time_Units__c,Description__c,Servings__c FROM Recipe__c LIMIT 200];
        List<Recipe__c> recsInserted = new List<Recipe__c>();

        for(Recipe__c r: recs){

            r.Active_Time__c = 50;
            r.Description__c = 'Moderate recipe';
            r.Active_Time_Units__c = 'Minutes';
            r.Servings__c = 6;
            recsInserted.add(r);

        }

        Test.startTest();
            insert recsInserted;
        Test.stopTest();

        List<Recipe__c> recipesInserted = [SELECT Id, Name, Complexity__c, Description__c, Draft__c FROM Recipe__c WHERE Id = :recs];


        for(Recipe__c r: recipesInserted){
            System.assertEquals('Simple', r.Complexity__c, 'Recipe has less than an hour & <= 6 Servings - Simple Recipe');
        }
        
    }

    /*****************************************************************************************************************************************************
    //a.iii)Check if a task is created in Coookbook object. -----------
    //a.iii)Create recipe with the conditions for simple recipe. And assert as Simple.
    ******************************************************************************************************************************************************/

    @isTest
    static void hasCookbookTaskCreated(){
        List<Recipe__c> rec = [SELECT Id, Name, Active_Time__c, Active_Time_Units__c, Complexity__c, Description__c, Draft__c FROM Recipe__c LIMIT 200];
        List<Cookbook__c> cookbookList = [SELECT Name, Publish_Date__c,Status__c FROM Cookbook__c LIMIT 200];
        List<Recipe_Usage__c> recUsage = [SELECT Id, Recipe__c,Cookbook__c FROM Recipe_Usage__c];
        
        for(Recipe__c r : rec){
            
            r.Active_Time__c = 45;
            r.Active_Time_Units__c = 'Minutes';
            r.Description__c = 'Cookbook Task Created Recipe';
            r.Servings__c = 15;
            rec.add(r);
        }
         
        insert rec;
                
        Test.startTest();
            
            insert recUsage; 

        Test.stopTest();
        
        List<Task> cbTasks = new List<Task>([SELECT Id, ActivityDate, Priority, Status, Subject, WhatId FROM Task WHERE WhatId = :cookbookList]);

        System.debug('Cookbook Tasks List created ....' + cbTasks);

        for(Cookbook__c cb: cookbookList){
            for(Task t: cbTasks){
            //System.assertEquals(2, cbTasks.size() ,'Task created for Cookbooks associated with Recipe...');
            System.assertEquals(cb.Id, t.WhatId ,'Task created for Cookbooks associated with Recipe...');
            }

        }
    }

    /*****************************************WEEK 6 Homework********************************************/

    /*************************************************************************************************
    Week6.i)Add negative tests to the Recipe trigger handler class you created last week
            Write at least one test method that validates your code doesn’t do something it shouldn’t 
            (but could if your code was sloppy or missed a requirement)

        Solution : line 4-10 +line 250 - 314
    **************************************************************************************************/
    //If a recipe is referred to a Cookbook which is already having that recipe.
    
    //NegativeTest - Missing Requirement/Logic
    @isTest
    static void recipeDuplicateinCookbook(){

        //Create a recipe r1
        Recipe__c r1 = new Recipe__c();
        r1.Name = 'Paneer Butter Masala';
        r1.Active_Time__c = 45;
        r1.Active_Time_Units__c ='Minutes';
        r1.Description__c = 'Side Dish';
        r1.Servings__c = 8;
        insert r1;

        //Create a Cookbook c
        Cookbook__c c = new Cookbook__c();
        c.Publish_Date__c = System.Today()+10;
        c.Status__c = 'To Be Published';
        insert c;

        //Recipe r1 in cookbook c - For the first time
        Recipe_Usage__c ru1 = new Recipe_Usage__c();
        ru1.Recipe__c = r1.id;
        ru1.Cookbook__c = c.id;
        insert ru1;
        
        
        Boolean b = false;

        //Recipe r1 in cookbook c - adding 2nd time as duplicate
        Recipe_Usage__c ru2 = new Recipe_Usage__c();
        ru2.Recipe__c = r1.id;
        ru2.Cookbook__c = c.id;

        try{
        Test.startTest();        
        if(ru1.Recipe__r.id != ru2.Recipe__r.id){
            insert ru2;
        Test.stopTest();
        }

        }  catch (MyException m){

            System.debug('Recipe already existing in Cookbook'+m.getMessage());
            b = True;

        } catch (DmlException dmle){

            System.debug('Dml Exception'+dmle.getMessage());
            b = True;

        } catch (Exception e){

            System.debug('Generic Exception'+e.getMessage());
            b = True;
        }
      

        System.assertEquals(b,True,'Exception Caught');
        

    }



    /*****************************************************************************************************
    6.ii) Exception Testing
          Our requirements have changed!  
          Instead of marking a Recipe as Draft when it is missing a required field, throw an error instead. 
          (Hint:  look at the addError in IngredientUtil)
           Note: Of course this could be done declaratively, this is to show the pattern when there are 
           conditions that can’t be handled declaratively.
        -------------------------------------------------
        Solution in RecipeTriggerHandler.cls (line 35-37)
    ******************************************************************************************************/
    
    
    
    /********************************************************************************************************
    Week6HW.iii) Write a test method that verifies an exception is thrown when a recipe is missing a required field.
           (hint:  you have to try first, catch the exception, then assert that the error was as expected.)
           Execute your tests in VSCode or in the Developer Console
           --------------------------------------------------
           Solution : line 337-368(missingReqFieldsException() Method)
    *********************************************************************************************************/
    @isTest
    static void missingReqFieldsException() {

        //How to test using TestFactory.prepareRecipeList(4,5,false)            
        List<Recipe__c> recs = TestFactory.prepareRecipeList(4,5,true);
        Boolean b = false;
        List<Recipe__c> notMissingFieldRecs = new List<Recipe__c>();

        try{
        Test.startTest();
            for(Recipe__c r:recs){
                if((String.isNotblank(r.Name)) || (r.Active_Time__c != null) || (String.isNotblank(r.Description__c)) || (String.isNotblank(r.Active_Time_Units__c)) || (r.Servings__c != null)) {
                    r.Servings__c = 6;
                    notMissingFieldRecs.add(r);
                }
            }
            update notMissingFieldRecs;
        Test.stopTest();
        } catch (MyException m) {
            
            System.debug('Recipe is missing required fields.Custom Exception.'+ m.getMessage());
            b = True;
        } catch (DmlException de) {
            System.debug('DML Exception.'+ de.getMessage());
            b = True;
        }    
        
        for(Recipe__c r: notMissingFieldRecs){
            System.assertEquals(null, notMissingFieldRecs.size(), 'Exception Caught');
            System.assertNotEquals(5, notMissingFieldRecs.size() , 'Exception Caught');
        }
    }
            

}    