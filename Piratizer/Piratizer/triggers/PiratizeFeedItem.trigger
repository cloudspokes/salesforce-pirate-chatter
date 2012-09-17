trigger PiratizeFeedItem on FeedItem (before insert, before update) {

	boolean isEnabled = false;
	List<Piratizer__c> pSettings = Piratizer__c.getAll().values();
	
	for(Piratizer__c p : pSettings){
		if(p.Is_Enabled__c && p.On_Chatter_Posts__c){
			isEnabled = true;
			break;
		}
	}
	
	if(isEnabled){
		for(FeedItem f : Trigger.new){
			f.body = PirateTranslator.getInstance().translate(f.body);
		}
	}
	
	
}