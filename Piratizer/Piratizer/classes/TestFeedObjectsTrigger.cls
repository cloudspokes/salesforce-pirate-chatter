/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
 /*
 
 	Test class for the Triggers on FeedItem and FeedComment Objects
 
 */
 
@isTest
private class TestFeedObjectsTrigger {

    static testMethod void testFeedObjects() {
        
         Profile pr = [Select Id from Profile where Name='Standard User'];
       
        // Insert the User for Testing
    	User u = new User();
    	u.Username  ='TestUser999@myTest.com';
    	u.LastName  ='Test User';      
    	u.Alias     = 'tst';
    	u.CommunityNickname = 'tst';  	
    	u.Email ='TestUser999@myTest.com';
    	u.EmailEncodingKey = 'UTF-8';
    	u.LanguageLocaleKey = 'en_US';
    	u.LocaleSidKey = 'en_US';
    	u.TimeZoneSidKey = 'America/Los_Angeles';
    	u.ProfileId = pr.Id;        	
       
        insert u;
        
        
        // Insert the Custom Settings
        Piratizer__c p = new Piratizer__c();
        p.Is_Enabled__c 		 = true;
        p.On_Chatter_Posts__c 	 = true;
        p.On_Chatter_Comments__c = true;
        p.Name = 'Test Piratizer';
        
        insert p;
        
        // Insert the Pirate Dictionary Records.
        List<Pirate_Dictionary__c> dictionary = new List<Pirate_Dictionary__c>();
        
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='Hello',Piratized_Version__c='Ahoy'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='beer',Piratized_Version__c='grog'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='friend',Piratized_Version__c='mate'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='girl',Piratized_Version__c='lass'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='the',Piratized_Version__c='ye'));
        
        insert dictionary;
        
        /* ACTUAL TEST STARTS HERE */
        // Insert the Feed Item Records, Trigger will be executed.
        
        List<FeedItem> feedItems = new List<FeedItem>();
        FeedItem f;
        
        // Insert the FeedItems
        for(Integer i=0;i<199;i++){
        	f = new FeedItem();
        	if(i < 100){
	        	f.Body = 'Chatter Test1 for friend drinking beer';
	        	f.ParentId = Userinfo.getUserId();
	        }
	        if(i >= 100 && i < 200){
	        	f.Body = 'Test2 for the girl. Hello friend';
	        	f.ParentId = u.Id;
	        }
	        f.Type = 'TextPost';
	        feedItems.add(f); 
        }
        
        insert feedItems;
        
        // Perform the Asserts.
        
        List<FeedItem> insertedF = [Select Id, Body from FeedItem where ParentId = :UserInfo.getUserId()];
        
        system.assertEquals(100,insertedF.size());
        
        for(FeedItem fi : insertedF)
        	system.assertEquals('chatter test1 for mate drinking grog',fi.Body);
       
       
        List<FeedItem> insertedF2 = [Select Id, Body from FeedItem where ParentId = :u.Id];
        
        system.assertEquals(99,insertedF2.size());
        
        for(FeedItem fi : insertedF2)
        	system.assertEquals('test2 for ye lass. Ahoy mate',fi.Body);
       
        
        
        // Insert the Feed Comments
        
        List<FeedComment> feedComments = new List<FeedComment>();
        FeedComment fc;
        
        for(Integer i=0;i<199;i++){
        	fc = new FeedComment();
        	if(i < 100){
	        	fc.CommentBody = 'Comment Chatter Test1 for friend drinking beer';
	        	fc.FeedItemId = feedItems[i].Id;
	        }
	        if(i >= 100 && i < 200){
	        	fc.CommentBody = 'Comment Test2 for the girl. Hello friend';
	        	fc.FeedItemId = feedItems[i].Id;
	        }
	        fc.CommentType = 'TextComment';
	        feedComments.add(fc); 
        }
        
        insert feedComments;
        
        // Perform the Asserts
        
        List<FeedComment> insertedFC1 = [Select Id, CommentBody from FeedComment where ParentId = :UserInfo.getUserId()];
        
        system.assertEquals(100,insertedFC1.size());
        for(FeedComment c: insertedFC1)
        	system.assertEquals('comment chatter test1 for mate drinking grog',c.CommentBody);
        
        List<FeedComment> insertedFC2 = [Select Id, CommentBody from FeedComment where ParentId = :u.Id];
        
        system.assertEquals(99,insertedFC2.size());
        for(FeedComment c: insertedFC2)
        	system.assertEquals('comment test2 for ye lass. Ahoy mate',c.CommentBody);	
        
        
    }
}