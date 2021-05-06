@isTest
// Test Data factory for RAD Part-2 Final Project
public class TestDataFactory {
    public TestDataFactory() {

    }

    //Method 1 & 2 
    /*********************************************************************************************************
     Method 1: Creates and returns a list of Ingredient SObject records with dummy data.  
     It should take a parameter that dictates the number of Ingredient objects to be returned
     Each Ingredient in the list should have a different name (hint, this can be Ingredient1, Ingredient2 etc)
     It should create the objects in-memory and return them, WITHOUT INSERTING
     *********************************************************************************************************/

    Public static List<Ingredient__c> ingredientsWithoutRecipe(Integer noOfIngredients, Boolean doInsert){
		
        List<Ingredient__c> ingrList = new List<Ingredient__c>();

            for(Integer i=0; i< noOfIngredients; i++) {
                Ingredient__c ingr = new Ingredient__c();
                ingr.Name = 'Ingredient'+(i+1);
                ingr.Measurement__c = i + 1;
                ingr.Measurement_Type__c = 'Cups';
                ingrList.add(ingr);
            }
            if(doInsert){
                insert ingrList; //ingrList false. Without Recipe Id can't insert ingredient.
            }
		return ingrList;
    }

    Public static List<Ingredient__c> ingredientsWithRecipe(Integer noOfIngredients, String recipeId, Boolean doInsert){
		
        List<Ingredient__c> ingrList = new List<Ingredient__c>();

            for(Integer i=0; i< noOfIngredients; i++) {
                Ingredient__c ingr = new Ingredient__c();
                ingr.Name = 'Ingredient'+(i+1) ;
                ingr.Measurement__c = i + 1;
                ingr.Measurement_Type__c = 'Cups';
                ingr.Recipe__c = recipeId;
                ingrList.add(ingr);
            }
            if(doInsert){
                insert ingrList;
            }
		return ingrList;
    }

    Public static List<Ingredient__c> ingredientsWithRecipeList(Integer noOfIngredients, List<Recipe__c> recs, Boolean doInsert){


        List<Ingredient__c> ingrList = new List<Ingredient__c>();

            for(Recipe__c r: recs){

                for(Integer i=0; i< noOfIngredients; i++) {
                    Ingredient__c ingr = new Ingredient__c();
                    ingr.Name = 'Ingredient'+(i+1) ;
                    ingr.Measurement__c = i + 1;
                    ingr.Measurement_Type__c = 'Cups';
                    ingr.Recipe__c = r.id;                 
                    ingrList.add(ingr);
                }
            }
            if(doInsert){
                insert ingrList;
            }
		return ingrList;
    }

    
    /*******************************************************************************************
       Method 3: Creates, inserts and returns a list of Recipe SObject records with dummy data.  
       It should take parameters that: 
            - dictates the number of Recipe objects to be created and returned 
            - An Ingredient that should be created and added to each Recipe
            Hint: Can you use the methods you wrote for Ingredient to help you with this??
            Bonus: Can you create an additional method that does all the above, but also allows 
            you to pass in a list of ingredients to add to each recipe?

     ********************************************************************************************/

    
     //recInsert = true; ingInsert = false ; doInsert = true  
    Public static List<Recipe__c> prepareRecipeListWIngredients(Integer noOfRecipes, Integer noOfIngredients, Boolean recInsert, Boolean ingInsert, Boolean doInsert){
		
        List<Recipe__c> recipeList = new List<Recipe__c>();

            for(Integer r=0; r< noOfRecipes; r++) {
                Recipe__c rec = new Recipe__c();
                rec.Name = 'Recipe'+(r+1);
                rec.Active_Time__c = 50;
                rec.Active_Time_Units__c = 'Minutes';
                rec.Description__c = 'Recipe'+(r+1);
                rec.Servings__c = 10;
                recipeList.add(rec);               
            }
            
            if(recInsert){
                insert recipeList;
            }
            System.debug('Recipe List'+recipeList);

            List<Ingredient__c> ingredients = ingredientsWithoutRecipe(noOfIngredients,ingInsert); //Pass false to ingInsert


            for(Recipe__c re:recipeList){
                for(Ingredient__c ing:ingredients){
                    ing.Recipe__c = re.Id;
                }
            }
            if(doInsert){
                insert ingredients;
            }
		return recipeList;
    }

    //recInsert = true; ingInsert = false ; doInsert = true  
    Public static List<Recipe__c> prepareRecipeListOnly(Integer noOfRecipes, Boolean doInsert){
		
        List<Recipe__c> recipeList = new List<Recipe__c>();

            for(Integer r=0; r< noOfRecipes; r++) {
                Recipe__c rec = new Recipe__c();
                rec.Name = 'Recipe'+(r+1);
                rec.Active_Time__c = 50;
                rec.Active_Time_Units__c = 'Minutes';
                rec.Description__c = 'Recipe'+(r+1);
                rec.Servings__c = 10;
                recipeList.add(rec);               
            }
            
            if(doInsert){
                insert recipeList;
            }
            System.debug('Recipe List'+recipeList);

            return recipeList;
    }

}
