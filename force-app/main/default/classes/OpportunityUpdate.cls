public with sharing class OpportunityUpdate {

    public static void updateCloseDates(List<Opportunity> opps) {
        List<Opportunity> toUpdate = new List<Opportunity>();
        //test
        for (Opportunity opp : opps) {
            toUpdate.add(new Opportunity(
                Id = opp.Id,
                CloseDate = Date.today().addDays(5)
            ));
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
