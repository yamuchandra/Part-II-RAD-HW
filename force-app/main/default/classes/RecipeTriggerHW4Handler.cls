public class RecipeTriggerHW4Handler {

    //***********Create a trigger handler class that will be called by the trigger and which will handle the business logic************

    // -----------Trigger Recursion Control------------------------------------------------------

	public static boolean hasExecuted = false; //Has the Contact trigger already executed? -- The Trigger updates this variable when first run
    
    // -----------Trigger Handler Class Variables -----------------------------------------------

    List<Recipe__c> newRecipes;
    Map<ID, Recipe__c> newRecipeMap;

    //------Constructor receives the recipes being processed by this trigger and assigns them to class variables--------

    public RecipeTriggerHW4Handler (List<Recipe__c> newRecipes1, Map<ID, Recipe__c> newRecipeMap1) {
        this.newRecipes = newRecipes1;
        this.newRecipeMap = newRecipeMap1;
    }


    public void beforeInsertUpdate(){

        /***** 1.b.i) Create a method that will be called before a recipe is inserted or updated to check if it is missing key values.*****
                  If it is missing one or more of the following, check the Draft__c field on the recipe:******
                  Name, Active_Time__c, Description__c, Active_Time_Units__c, Servings__c ******/

        for(Recipe__c recipe: this.newRecipes) {

            if((recipe.Name == null) || (recipe.Active_Time__c == null) || (recipe.Description__c == null) || (recipe.Active_Time_Units__c == null) || (recipe.Servings__c == null)) {
                                
                recipe.Draft__c = True;
                System.debug('Draft recipe');

            }

        }

        /* **** 1.b.ii) We also want to rate the complexity of a recipe. Create a method that checks before a recipe is inserted or updated and does the following:
                Calls out to a method on the HelperFunctions class called rateRecipeComplexity. This method already exists in your org!
                Gets the numerical rating back from the method and use it to fill in the Complexity__c field.
                FYI: If the method returns a 3, that’s ‘Difficult’, a 2 is ‘Moderate’ and a 1 is ‘Simple’
                Your method on the trigger handler needs to get the rating for each recipe in the trigger and update the Complexity field. ***** */


        for(Recipe__c recipe: this.newRecipes) {

            Integer retRating;
            retRating = HelperFunctions.rateRecipeComplexity(recipe);  
            
            System.debug('Recipe rating number ' + retRating);
            
            if(retRating == 3){
                recipe.Complexity__c = 'Difficult';
            }
            else if(retRating == 2){
                recipe.Complexity__c = 'Moderate';
            }
            else if(retRating == 1){
                recipe.Complexity__c = 'Simple';
            }
        }  

    }                  


    public void handleAfterUpdate() {

        /* ***** 1.b.111) After a recipe is updated, if it’s not a draft recipe, and if it’s being used in any cookbooks, we want to create a review task.  
                  So let’s break that down.  
                  Criteria (which records need a task?)
                  If the recipe is not a draft
                  If the recipe is used in at least one cookbook
                  Check for a Recipe Usage record, indicating this recipe is used in a cookbook
                  Work (What your code in the trigger handler should do with these records)
                  Create a Review task for each cookbook in which this recipe appears
                  That means the task should be on the cookbook record (not the recipe)
                  Assign to the user who owns the cookbook
                  Make the task due-date 1 week from today
                  Hint: Date system methods!!
                  Insert the Task 
                  Is your DML bulkified?? ***** */

        List<Task> reviewTask = new List<Task>();

        Map<Id,Recipe__c> cookbookRecipe = new Map<Id,Recipe__c>([SELECT ID, (SELECT ID,Recipe__c,Cookbook__c FROM Recipe_Usages__r ) FROM Recipe__c WHERE ID IN :this.newRecipes]);
        System.debug('cookbookRecipe Map items: ' + cookbookRecipe);

        
        for(Recipe__c recipe: this.newRecipes) {            

            if((recipe.Draft__c == false) && (!cookbookRecipe.isEmpty())){

                System.debug('Is Draft' + recipe.Draft__c + ' Cookbook refers Recipe? ' + cookbookRecipe.isEmpty() );

                Task cbtask = new Task();
                Recipe__c c = cookbookRecipe.get(recipe.id);//.get(Recipe_Usages__r.id).Cookbook__c.id;
                System.debug('hello' +c);
                //cbtask.OwnerId = cookbookRecipe.get(recipe.id).Recipe_Usages__r.Cookbook__c.OwnerId;
                cbtask.ActivityDate = System.today() + 7;
                reviewTask.add(cbtask);
                                
            }
        }
        
        insert reviewTask;
    }                 
                 
                 
        /* ***** 1.b.iv) Check your work!!
                There is a test class already in your code called WeekFourHomeworkCheck and it contains test methods that will check and see if your code works!  
                Run the tests in VSCode or the Developer Console.   If one or more of the test methods fail, check the error message and location and try to 
                debug and fix the issue. ***** */

}
