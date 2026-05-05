@IsTest
private class OpportunityUpdateTest {

    @IsTest
    static void testTrigger_NameContainsTest_CloseDateUpdated() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        Opportunity result = [SELECT CloseDate FROM Opportunity WHERE Id = :opp.Id];
        Assert.areEqual(Date.today().addDays(5), result.CloseDate,
            'CloseDate should be set to 5 days from today');
    }

    @IsTest
    static void testTrigger_NameDoesNotContainTest_CloseDateUnchanged() {
        Date originalCloseDate = Date.today().addDays(30);
        Opportunity opp = new Opportunity(
            Name = 'Regular Opportunity',
            StageName = 'Prospecting',
            CloseDate = originalCloseDate
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        Opportunity result = [SELECT CloseDate FROM Opportunity WHERE Id = :opp.Id];
        Assert.areEqual(originalCloseDate, result.CloseDate,
            'CloseDate should remain unchanged for non-Test opportunities');
    }

    @IsTest
    static void testOpportunityUpdate_DirectCall_SetsCloseDate() {
        Opportunity opp = new Opportunity(
            Name = 'Direct Call Test',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert opp;

        Test.startTest();
        OpportunityUpdate.updateCloseDates(new List<Opportunity>{ opp });
        Test.stopTest();

        Opportunity result = [SELECT CloseDate FROM Opportunity WHERE Id = :opp.Id];
        Assert.areEqual(Date.today().addDays(5), result.CloseDate,
            'CloseDate should be 5 days from today after direct class call');
    }

    @IsTest
    static void testTrigger_BulkInsert_AllTestOppsUpdated() {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 200; i++) {
            opps.add(new Opportunity(
                Name = 'Test Bulk Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }

        Test.startTest();
        insert opps;
        Test.stopTest();

        for (Opportunity result : [SELECT CloseDate FROM Opportunity WHERE Id IN :opps]) {
            Assert.areEqual(Date.today().addDays(5), result.CloseDate,
                'All bulk Test opportunities should have CloseDate set to 5 days from today');
        }
    }
}