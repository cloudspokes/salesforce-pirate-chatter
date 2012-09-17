/***************************************************************************
 Name         : PirateTranslator
 Author       : Kartik Viswanadha (kartik.viswanadha@gmail.com)
 Description  : Main class that translates the English Sentence to Pirate.
 Operations:  : The class has the translator method that translates the sentence and also a getPirateMap method that returns the Pirate Dictionary as a Map. This class
 				uses the singleton pattern, so that the Map is created only once.
****************************************************************************/

public with sharing class PirateTranslator {
	
	private map<String,String> pirateEngMap; // Holds the Eng, Pirate Map
	private static PirateTranslator self;
	
	// Constructor is private
	private PirateTranslator(){
	
		pirateEngMap = new Map<String,String>();
		
		for(Pirate_Dictionary__c d : [Select Id, English_Version__c, Piratized_Version__c from Pirate_Dictionary__c])
			pirateEngMap.put(d.English_Version__c.toLowerCase(),d.Piratized_Version__c);
		
	}
	
	
	// Get the instance once. 
	public static PirateTranslator getInstance(){
		
		if(self != null)
			return self;
		
		self = new PirateTranslator();
		
		return self;	
	
	}
	// Return the Pirate Map.
	public Map<String,String> getPirateMap(){
		
		if(self == null)
			self = new PirateTranslator();
		
		return pirateEngMap;
	}
	
	/*
		Main logic to translate the English to Pirate. Arguments are EngPhrase and returns the String in Pirate.
	*/

	public String translate(String engPhrase){
		
		if(self == null)
			self = new PirateTranslator();
		
		engPhrase = engPhrase.toLowerCase(); // Convert to Lower Case.
		
		Pattern nonWordChar = Pattern.compile('[^\\w]'); // All Non-Word Characters Pattern.
		
		if(pirateEngMap.size() == 0) // If no words in Pirate Dictionary, return the phrase as it is.
			return engPhrase;
		
		// Split each word in the phrase and verify if pirate version of the word is available. Splitting is happening at every space, so replace the non-word characters
			
		for(String s : engPhrase.split(' ')){
			s = nonWordChar.matcher(s).replaceAll(''); 
			if(pirateEngMap.get(s) != null){ // If piratized version of eng word is available, replace it in the phrase.
				engPhrase = engPhrase.replace( ' ' + s ,  ' ' + pirateEngMap.get(s));	
				engPhrase = engPhrase.replace( s + ' ', pirateEngMap.get(s) + ' ');
				engPhrase = engPhrase.replace( '.' + s, '.' + pirateEngMap.get(s));
				engPhrase = engPhrase.replace( ',' + s, ',' + pirateEngMap.get(s));
				engPhrase = engPhrase.replace( ';' + s, ';' + pirateEngMap.get(s));
				engPhrase = engPhrase.replace( '!' + s, '!' + pirateEngMap.get(s));
				engPhrase = engPhrase.replace( ':' + s, ':' + pirateEngMap.get(s));
				engPhrase = engPhrase.replace( '?' + s, '?' + pirateEngMap.get(s));
				engPhrase = engPhrase.replace( '-' + s, '-' + pirateEngMap.get(s));
			}
		}
	
		return engPhrase; // return the phrase.
	}
	
}