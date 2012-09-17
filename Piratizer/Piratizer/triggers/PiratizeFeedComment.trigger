trigger PiratizeFeedComment on FeedComment (before insert, before update) {

	boolean isEnabled = false;
	List<Piratizer__c> pSettings = Piratizer__c.getAll().values();
	
	for(Piratizer__c p : pSettings){
		if(p.Is_Enabled__c && p.On_Chatter_Comments__c){
			isEnabled = true;
			break;
		}
	}

	if(isEnabled){
		for(FeedComment f : Trigger.new){
			f.CommentBody = PirateTranslator.getInstance().translate(f.CommentBody);
		}
	}
	

}