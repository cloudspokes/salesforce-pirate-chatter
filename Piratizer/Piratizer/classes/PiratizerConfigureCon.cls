/***************************************************************************
 Name         : PiratizerConfigureCon
 Author       : Kartik Viswanadha (kartik.viswanadha@gmail.com)
 Description  : Controller class for the PiratizerConfigre Page.
 Operations:  : This page is used for Configure option on a package install. This page allows to enable Piratizer for 1st time and load the Pirate Dictionary.
****************************************************************************/

public with sharing class PiratizerConfigureCon {


	public boolean configAlreadySet				 {get;set;}	
	public boolean isLoaded						 {get;set;}	
	public List<Pirate_Dictionary__c> dictionary {get;set;}
	public HttpResponse testResponse;	
	
	private String YAHOOURL = 'http://query.yahooapis.com/v1/public/';	
	
	// Constructor.
	
	public PiratizerConfigureCon(){
		
		configAlreadySet = false;
		isLoaded		 = false;
		
		List<Piratizer__c> pConfigs 	= new List<Piratizer__c>();		
		pConfigs 						= [Select Name, Is_Enabled__c, On_Chatter_Posts__c, On_Chatter_Comments__c from Piratizer__c LIMIT 1];
		
		if(pConfigs.size() > 0){
			configAlreadySet = true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Piratizer Settings already present for Chatter Feed and Chatter Comments'));
	
		}
		
	}
	
	// Enable the Configuration for 1st Time
	
	public void enableConfig(){
			
			Piratizer__c p 			 = new Piratizer__c();
        	p.Is_Enabled__c 		 = true;
       		p.On_Chatter_Posts__c 	 = true;
        	p.On_Chatter_Comments__c = true;
        	p.Name					 = 'Piratizer';
        	
        	insert p;
        	
        	configAlreadySet = true;
		
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Piratizer Enabled for Chatter Feed and Chatter Comments'));
	
	}
	// Load the Pirate Dictionary from Yahoo API. 
	
	public void loadfromYahoo(){
		
		dictionary = new List<Pirate_Dictionary__c>();
    
		Pirate_Dictionary__c pd;
		
		String yql = 'yql?q=select%20*%20from%20piratespeak.dictionary%20&format=json&env=store%3A%2F%2Fkid666.com%2Fpiratespeak'; // Yahoo Query Language 
		
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(YAHOOURL + yql);
		
		Http http  = new Http();
		
		HttpResponse res = new HttpResponse();
		
		if(!Test.isRunningTest())	
			res = http.send(req);
		else
			res = testResponse;
		
		String jsonResponse = res.getBody();
		
		JSONParser parser = JSON.createParser(jsonResponse);
    	while (parser.nextToken() != null) {	
		 	 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'result')){
		 
		 	 	while (parser.nextToken() != null) {	
		 	 		if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
			 	 		pd = new Pirate_Dictionary__c();
			 	 		pd.English_Version__c = parser.getText();
			 	 		system.debug('in here text ' + parser.getText());
			 	 		parser.nextToken();
			 	 	
			 	 		if(parser.getCurrentToken() != JSONToken.START_ARRAY){
			 	 			pd.Piratized_Version__c = parser.getText();
			 	 			 system.debug('in here text value' + parser.getText());
			 	 			dictionary.add(pd);
			 	 		}else{
			 	 			parser.nextToken();
			 	 			pd.Piratized_Version__c = parser.getText();
			 	 			dictionary.add(pd);
			 	 		}
		 	 		}
		 	 	}
		 	 }
    	}
    	
    	if(dictionary.size() > 0)
    		isLoaded = true;
    	
	}
	
	// Save the Dictionary loaded from Yahoo into Pirate Dictionary Object.
	
	public Pagereference saveDictionary(){
		
		insert dictionary;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Inserted Pirate Dictionary Samples'));
		
		Schema.DescribeSObjectResult r 		   = Pirate_Dictionary__c.sObjectType.getDescribe();
		String prefix	 					   = r.getKeyPrefix(); 
		
		return new Pagereference('/'+prefix);
		
	}
	
	/*
		-------------- TEST METHOD ---------------------
	*/
	
	static testmethod void testPiratizerConfigureCon(){
		
		PiratizerConfigureCon testCon = new PiratizerConfigureCon();
		
		testCon.enableConfig();
		
		List<Piratizer__c> pConfigs 	= new List<Piratizer__c>();		
		pConfigs 						= [Select Name, Is_Enabled__c, On_Chatter_Posts__c, On_Chatter_Comments__c from Piratizer__c LIMIT 1];
		
		system.assertEquals(1, pConfigs.size()); // Assert 
		
		String testJSON = '{\"query\":{\"count\":1,\"created\":\"2012-08-31T02:27:29Z\",\"lang\":\"en-US\",\"results\":{\"result\":{\"comes\":\"hails\",\"friends\":\"crew\",\"your\":\"ye\",\"right\":\"starboard\",\"woman\":\"wench\",\"lawyer\":\"scurvy land lubber\",\"hello\":[\"ahoy\",\"avast\"],\"the\":[\"ye\",\"yonder\",\"thar\"],\"girl\":\"lass\",\"is\":\"be\",\"boy\":\"cabin boy\",\"person\":\"landlubber\",\"friend\":\"mate\",\"beer\":\"grog\",\"left\":\"port\",\"yes\":[\"yarr\",\"aye\"],\"are\":\"be\"}}}}';
		
		HttpResponse testRes = new HttpResponse();
		testRes.setStatus('200');
		testRes.setBody(testJSON);
		
		testCon.testResponse = testRes;
		
		testCon.loadfromYahoo();
		
		system.assertEquals(true, testCon.isLoaded); // Assert 
		
		testCon.saveDictionary();
		
		List<Pirate_Dictionary__c> newInserts = new List<Pirate_Dictionary__c>();
		newInserts = [Select Id, English_Version__c, Piratized_Version__c from Pirate_Dictionary__c];
		
	}
	


}