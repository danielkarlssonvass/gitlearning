trigger OpportunityTrigger on Opportunity (after insert) {
    List<Opportunity> testOpps = new List<Opportunity>();

    for (Opportunity opp : Trigger.new) {
        if (opp.Name != null && opp.Name.containsIgnoreCase('Test')) {
            testOpps.add(opp);
        }
    }

    if (!testOpps.isEmpty()) {
        OpportunityUpdate.updateCloseDates(testOpps);
    }
}
