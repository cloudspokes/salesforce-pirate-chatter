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
 
 /* Test the Pirate Translator Class */
 
@isTest
private class TestPirateTranslator {

    static testMethod void myUnitTest() {
        
        // Load the Pirate Dictionary.
        
        List<Pirate_Dictionary__c> dictionary = new List<Pirate_Dictionary__c>();
        
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='Hello',Piratized_Version__c='Ahoy'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='beer',Piratized_Version__c='grog'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='friend',Piratized_Version__c='mate'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='girl',Piratized_Version__c='lass'));
        dictionary.add(new Pirate_Dictionary__c(English_Version__c='the',Piratized_Version__c='ye'));
        
        insert dictionary;
        
        // Test the Class
        
        String engSentence = 'Hello Friend. This is test';
        
        Map<String,String> insertedMap = PirateTranslator.getInstance().getPirateMap();	 // Get the Pirate Map
        
        system.assertEquals(5, insertedMap.size()); // Assert
        
        String pirateSentence = PirateTranslator.getInstance().translate(engSentence); // Translate the Eng phrase to Pirate
        
        system.assertEquals('Ahoy mate. this is test', pirateSentence); // Assert.
        
        
    }
}