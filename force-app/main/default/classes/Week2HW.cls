//Coding Practice
//In your Dev Org with the RAD Package, Open the SOQLExercises.cls.  
//You will have seen some or all of this in-class.  Run through each demo method
//and run the sample queries to review results.  
//You can do this in either the Dev Console, or directly in VSCode.
//Your turn!
//Create a new Apex class called WeekTwoHomework.

public with sharing class Week2HW {

    //Create the following methods. You can use any criteria you like,
    //based on the sample data in your developer org, with the following requirements.
    
    //Method :1 A method that includes a query for a List of contacts and returns the Account Name and Industry as well.
    //Use a loop to print the name of each Contact’s Account Name with System.debug.
        public static void childToParentRelationshipQueries() {
           
           List<Contact> conAcc = [SELECT ID, Name, AccountId, Account.Name, Account.Industry FROM Contact WHERE MailingState = 'CA'];
           Integer n = conAcc.size();
           system.debug('List Size'+n);
           for (contact ca: conAcc) {
                //To print out the whole List result object:
                system.debug('ca:'+ca);
           }
               
               //Something wrong in the below code.....
               //Error in Line 28 : "Expression must be a list type: Contact". Rectified. Changed to conAcc - list name + out of first for loop.
               
           for(Integer i=0;i<n;i++){
                System.debug('   Contact : '+ conAcc[i].Name +'..........'+'Account Name : '+conAcc[i].Account.Name);
           }
       
    }
    
    //Method 2: A method that includes a query for a list of Accounts AND includes all their closed-won opportunities
    //in a subquery. Use a loop to print out the name of each Account’s opportunity with System.debug.
       
        public static void parentToChildrenRelationshipQueries () {
    
                Account[] acctsWithWonOpps = [
    SELECT Name,Industry, (SELECT Amount,LeadSource FROM Opportunities WHERE StageName='Closed Won')
                FROM Account
                ];
                Integer m = acctsWithWonOpps.size();
    
                System.debug('Our Accounts with closed-won opportunities are: '+ acctsWithWonOpps);
               
               //Each Account's Closed-Won Opportunity/ies
           
               for(Integer i=0;i<m;i++){
               System.debug('   Account : '+ acctsWithWonOpps[i].Name +'..........'+'Opportunity/ies : '+ acctsWithWonOpps[i].Opportunities);
               }          
        }
    
    
    //Method 3: A method that queries for Opportunity records that returns results in a map format.
    //An aggregate results query that returns an integer equal to the total number of open opportunities in your org.
    
        public static void convertingCollectionTypes () {
    
    List < Opportunity > opps = [SELECT ID, Name, Amount, StageName FROM Opportunity WHERE Amount > 10000];
    
    
    //Let's convert that list to a map.
    //Opt:1 Pass the list into a map constructor:
    
    Map < ID, Opportunity > oppMap = new Map < ID, Opportunity >(opps);
            System.debug('Map'+oppMap);
    
    //Opt2: or, instantiate an empty map and then add the whole list to it
    
    Map < ID, Opportunity > anotherOppMap = new Map < ID, Opportunity >();
    anotherOppMap.putAll(opps);
           
            //Not sure - about the below code
            //Aggregate Query for Open Opportunities
            //Best Practice: Avoid negative queries(!=)
            Integer closedOppsCount1 = [SELECT COUNT() FROM Opportunity WHERE StageName = 'Closed Won'];
            System.debug('Closed Opps1'+closedOppsCount1);
            Integer closedOppsCount2 = [SELECT COUNT() FROM Opportunity WHERE StageName = 'Closed Lost'];
            System.debug('Closed Opps2'+closedOppsCount2);
            Integer totalOppsCount = [SELECT COUNT() FROM Opportunity];
            System.debug('Total Opps'+totalOppsCount);
            Integer openOppsCount = totalOppsCount - (closedOppsCount1 + closedOppsCount2) ;
    System.debug('We have ' + openOppsCount + ' Open Opportunities.');
    }
    
    
    
    }