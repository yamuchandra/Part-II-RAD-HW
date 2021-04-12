//Test Factory example from Trailhead: https://trailhead.salesforce.com/en/content/learn/modules/unit-testing-on-the-lightning-platform/generate-data-for-tests

@isTest
public class TestFactory {

    public static Account getAccount(String name, Boolean doInsert){
        Account a = new Account(name = name);
        if(doInsert){
            insert a;
        }
        return a;
    }

    public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
        Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId);
        if(doInsert){
            insert c;
        }
        return c;
    }

    public static void generateAccountWithContacts(Integer numContacts){
        Account a = getAccount('default account ltd', true);
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < numContacts; i++){
            String contactName = 'contact' + i;
            contacts.add(getContact(a.id, contactName, contactName, false));
        }
        insert contacts;
    }

    public static Opportunity[] generateOppsForAccount(id accountId, Decimal amount, Integer numOpps){
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            Opportunity o = new Opportunity();
            o.name = 'Account ' + i;
            o.accountId = accountid;
            o.amount = amount;
            o.closeDate = Date.today().addDays(5);
            o.stageName = 'Prospecting';
            opps.add(o);
        }
        return opps;
    }
    
    public static User generateUser(String profileName){
        UserRole userRole = new UserRole(DeveloperName = 'TestingTeam', Name = 'Testing Team');
        insert userRole;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
            LastName = 'last',
            Email = 'Cpt.Awesome@awesomesauce.com',
            Username = 'Cpt.Awesome@awesomesauce.com',
            CompanyName = 'Testing Co',
            Title = 'Captian',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = userRole.Id
        );
        insert u;
        return u;
    }

    
    /**********************************
    * My Method for RecipeList Creation 
    ***********************************/

    Public static List<Recipe__c> prepareRecipeList(Integer Servings, Integer noOfRecipes, Boolean doInsert){
		
        List<Recipe__c> recipeList = new List<Recipe__c>();
 		
            For(Integer i=0; i< noOfRecipes; i++){

			    Recipe__c recipeRecord = new Recipe__c();
                recipeRecord.Name = 'Gulab' +i;
                recipeRecord.Active_Time__c = i + 1;
                recipeRecord.Servings__c = Servings;
			    recipeList.add(recipeRecord);		
		    }
            if(doInsert){
                insert recipeList;
            }
		return recipeList;
    }

    /************************************
    * My Method for CookbookList Creation 
    *************************************/
    Public static List<Cookbook__c> prepareCookbookList(Integer noOfCookbooks, Boolean doInsert){

		List<Cookbook__c> cbList = new List<Cookbook__c>();

 		For(Integer i=0; i< noOfCookbooks;i++){
			Cookbook__c cbRecord = new Cookbook__c(Name='Main Course'+i, Publish_Date__c = System.Today()+10,Status__c = 'To Be Published');
			cbList.add(cbRecord);		
		}
        if(doInsert){
                insert cbList;
        }
		return cbList;
    }

    /***************************************
    * My Method for RecipeUsageList Creation 
    ****************************************/

    
    //Create recipeUsage Junction object records, by mentioning Recipe and Cookbook
    Public static List<Recipe_Usage__c> prepareRecipeUsageList(Boolean doInsert){

            List<Recipe__c> r = prepareRecipeList(4, 5, true);
            List<Cookbook__c> cb = prepareCookbookList(2, true);
		
        List<Recipe_Usage__c> recipeUsage = new List<Recipe_Usage__c>();
 		
            For(Integer i=0; i< r.size(); i++){
                For(Integer j=0; j< cb.size(); j++){
                    
                    Recipe_Usage__c recUsageRecord = new Recipe_Usage__c();
                    recUsageRecord.Cookbook__c = cb[j].Id;
                    recUsageRecord.Recipe__c = r[i].Id;
			        recipeUsage.add(recUsageRecord);
                    System.debug('Every recipe Usage Rrecord****'+recUsageRecord);
                }		
		    }


            if(doInsert){
                insert recipeUsage;
            }
            System.debug('Recipe Usage records Created...'+recipeUsage)
		return recipeUsage;
    }
}
