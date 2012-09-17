/***************************************************************************
 Name         : NewPirateWordsExt
 Author       : Kartik Viswanadha (kartik.viswanadha@gmail.com)
 Description  : Extension class for the VF page NewPirateWords
 Operations:  : The class allows user to enter more than 1 English - Pirate Words in the Pirate Dictionary Object.
****************************************************************************/
public with sharing class NewPirateWordsExt {
	
	public List<Pirate_Dictionary__c> dictionaryWords{get;set;}
	public String engText{get;set;}
	public String pirateText{get;set;}
	
	private String prefix;
	
	
	// Constructor.
	public NewPirateWordsExt(Apexpages.StandardController con){
		
		dictionaryWords = new List<Pirate_Dictionary__c>();
		
		for(Integer i=0;i<10;i++){ // The default is set to 10, you can always change it to be more or less.
			dictionaryWords.add(new Pirate_Dictionary__c());		
		}
		
		Schema.DescribeSObjectResult r = Pirate_Dictionary__c.sObjectType.getDescribe();
		prefix	 					   = r.getKeyPrefix(); // Get the prefix of the object to return to the List page after the insert.
		
	}
	
	// Save method that saves the records in Pirate Dictionary object
	
	public Pagereference save(){
		
		List<Pirate_Dictionary__c> newdictionaryWords = new List<Pirate_Dictionary__c>();
		
		for(Pirate_Dictionary__c p : dictionaryWords){
			if(p.English_Version__c != null && p.Piratized_Version__c != null) // Ignore any null values.
				newdictionaryWords.add(p);
		}
		
		upsert newdictionaryWords;
		
		return new Pagereference('/'+prefix); // return to the List View
		
	}
	
	/*
		-------------------------------------- TEST METHOD -----------------------------------------
	*/
	
	static testmethod void testExtension(){
		
		Pirate_Dictionary__c pd 		 = new Pirate_Dictionary__c();
		Apexpages.Standardcontroller con = new Apexpages.Standardcontroller(pd);
		NewPirateWordsExt testExt 		 = new NewPirateWordsExt(con);
		
		
        List<Pirate_Dictionary__c> dictionary = new List<Pirate_Dictionary__c>();
        
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='Hello',Piratized_Version__c='Ahoy'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='beer',Piratized_Version__c='grog'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='friend',Piratized_Version__c='mate'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='girl',Piratized_Version__c='lass'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='the',Piratized_Version__c='ye'));
		dictionary.add(new Pirate_Dictionary__c());
		
		testExt.dictionaryWords = dictionary;
		
		testExt.save();
		
		List<Pirate_Dictionary__c> inserted = [Select Id from Pirate_Dictionary__c];
		
		system.assertEquals(5, inserted.size()); // Assert that the 5 values are inserted in the dictionary.
		
	}
	
	
}