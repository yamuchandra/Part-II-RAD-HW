public inherited sharing class RecipeController {
 
    //Add Ingredient to the Recipe
    @AuraEnabled
    public static void addIngredient(String ingredientName, Integer measurementAmount, String measurementType, ID recipeId){
	
        //Insert the ingredient
        
        System.debug('Before Adding Ingredient'+ingredientName+'..'+measurementAmount+'..'+measurementType+'...'+recipeId+'..');

        Ingredient__c i = new Ingredient__C();
            i.Name = ingredientName;
            i.Measurement__c = measurementAmount;
            i.Measurement_Type__C = measurementType;
            i.Recipe__c = recipeId;
 
        try{
            System.debug('Ingredient Before insert ...'+i);
            insert i;
            System.debug('Added ingredient Successfully'+i);
        } catch (DmlException de){
            System.debug('DML Exception occured'+de);
            System.debug('DML Exception Message'+de.getMessage());
            System.debug('StackTraceString'+de.getStackTraceString());
        } catch (Exception e) {
            System.debug('Exception occured'+e);
        }
    }
   
    //Get Ingredient List for a given Recipe
    @AuraEnabled
    public static List <Ingredient__c> generateGroceryList(Id recipeId){

        List<Ingredient__c> ingList;

	    //load the ingredients and return them
        try{
            ingList = [SELECT ID, Name, Measurement__c, Measurement_Type__c, Notes__c
                                       FROM Ingredient__c WHERE Recipe__r.Id = :recipeId ];                                     
            
        }
         
        catch (QueryException qe){
            System.debug('Query Exception : Message'+ qe.getMessage());
            System.debug('Query Exception : Cause'+ qe.getCause());
            System.debug('Query Exception : StackTraceString'+ qe.getStackTraceString());
        }
        catch (Exception e){
            System.debug('Exception : Message'+ e.getMessage());
            System.debug('Exception : Cause'+ e.getCause());
            System.debug('Exception : StackTraceString'+ e.getStackTraceString());
        }
        return ingList;
    }

    //Scale a Recipe for No. of Servings
    @AuraEnabled
    public static List <Ingredient__c> scaleRecipeForServings (ID recipeId, Decimal desiredServings) {
	    
        //Scale the recipe and return the list of scaled ingredients

        List<Ingredient__c> scaledIngrs = new List<Ingredient__c>();
        List<Ingredient__c> actualIngrs = [SELECT Id,Name,Measurement__c,Measurement_Type__C,Notes__c,Recipe__r.Servings__c FROM Ingredient__c WHERE Recipe__r.Id =: recipeId];
        System.debug('actual Ingredients of the Recipe...'+actualIngrs);

        for(Ingredient__c i : actualIngrs){
            
            i.Measurement__c = i.Measurement__c*(desiredServings/i.Recipe__r.Servings__c);
            scaledIngrs.add(i);
            System.debug('Ingredients Scaled...'+scaledIngrs);

        }
        return scaledIngrs;
    }
        
    //
    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] getAllRecipes() {
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            ORDER BY Name
            LIMIT 50
        ];
    }

    //Remove Ingredient from Recipe
    @AuraEnabled
    public static void removedIngredient(String ingredientName, ID recipeId){
	
        //Query for ingredient id
        Ingredient__c delIngr = [SELECT Id,Name FROM Ingredient__c WHERE recipe__r.id = :recipeId];
        
        try{
        if(delIngr.Name == ingredientName){
            delete delIngr;
        }
        } catch (DmlException de){
            System.debug('DML Exception Occured'+de.getMessage());
        }
    }

    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] searchRecipes(String searchTerm) {
        // Return all recipes when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            System.debug('returning: '+getAllRecipes());
            return getAllRecipes();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            WHERE Name LIKE :searchTerm
            ORDER BY Name
            LIMIT 50
        ];
    }
}
