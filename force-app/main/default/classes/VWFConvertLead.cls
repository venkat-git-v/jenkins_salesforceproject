// Converts a lead as an action in a flow.
global class VWFConvertLead implements Process.Plugin {
    // This method runs when called by a flow's legacy Apex action.
    global Process.PluginResult invoke(
        Process.PluginRequest request) {
            
        // Set up variables to store input parameters from 
        // the flow.
        String leadID = (String) request.inputParameters.get(
            'LeadID');
        String contactID = (String) 
            request.inputParameters.get('ContactID');
        String accountID = (String) 
            request.inputParameters.get('AccountID');
        String convertedStatus = (String) 
            request.inputParameters.get('ConvertedStatus');
        Boolean overWriteLeadSource = (Boolean) 
            request.inputParameters.get('OverwriteLeadSource');
        Boolean createOpportunity = (Boolean) 
            request.inputParameters.get('CreateOpportunity');
        String opportunityName = (String) 
            request.inputParameters.get('ContactID');
        Boolean sendEmailToOwner = (Boolean) 
            request.inputParameters.get('SendEmailToOwner');   
        
        // Set the default handling for booleans. 
        if (overWriteLeadSource == null) 
            overWriteLeadSource = false;
        if (createOpportunity == null) 
            createOpportunity = true;
        if (sendEmailToOwner == null) 
            sendEmailToOwner = false;
        
        // Convert the lead by passing it to a helper method.
        Map<String,Object> result = new Map<String,Object>();
        result = convertLead(leadID, contactID, accountID, 
            convertedStatus, overWriteLeadSource, 
            createOpportunity, opportunityName, 
            sendEmailToOwner);
 
        return new Process.PluginResult(result); 
    }
    
    // This method describes the plug-in and its inputs from
    // and outputs to the flow.
    // Implementing this method makes the class available 
    // in Flow Builder as a legacy Apex action.
    global Process.PluginDescribeResult describe() {
        // Set up plugin metadata
        Process.PluginDescribeResult result = new 
            Process.PluginDescribeResult();
        result.description = 
            'The LeadConvert Flow Plug-in converts a lead into ' + 
            'an account, a contact, and ' + 
            '(optionally)an opportunity.';
        result.tag = 'Lead Management';
        
        // Create a list that stores both mandatory and optional 
        // input parameters from the flow.
        // NOTE: Only primitive types (STRING, NUMBER, etc.) are 
        // supported. Collections aren't supported.
        result.inputParameters = new 
            List<Process.PluginDescribeResult.InputParameter>{
            // Lead ID (mandatory)
            new Process.PluginDescribeResult.InputParameter(
                'LeadID', 
                Process.PluginDescribeResult.ParameterType.STRING, 
                true),
            // Account Id (optional)
            new Process.PluginDescribeResult.InputParameter(
                'AccountID', 
                Process.PluginDescribeResult.ParameterType.STRING, 
                false),
            // Contact ID (optional)
            new Process.PluginDescribeResult.InputParameter(
                'ContactID', 
                Process.PluginDescribeResult.ParameterType.STRING, 
                false),            
            // Status to use once converted
            new Process.PluginDescribeResult.InputParameter(
                'ConvertedStatus', 
                Process.PluginDescribeResult.ParameterType.STRING, 
                true),
            new Process.PluginDescribeResult.InputParameter(
                'OpportunityName', 
                Process.PluginDescribeResult.ParameterType.STRING, 
                false),
            new Process.PluginDescribeResult.InputParameter(
                'OverwriteLeadSource', 
                Process.PluginDescribeResult.ParameterType.BOOLEAN, 
                false),
            new Process.PluginDescribeResult.InputParameter(
                'CreateOpportunity', 
                Process.PluginDescribeResult.ParameterType.BOOLEAN, 
                false),
            new Process.PluginDescribeResult.InputParameter(
                'SendEmailToOwner', 
                Process.PluginDescribeResult.ParameterType.BOOLEAN, 
                false)                                                   
        };

        // Create a list that stores output parameters sent 
        // to the flow.
        result.outputParameters = new List<
            Process.PluginDescribeResult.OutputParameter>{
            // Account ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter(
                'AccountID', 
                Process.PluginDescribeResult.ParameterType.STRING),
            // Contact ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter(
                'ContactID', 
                Process.PluginDescribeResult.ParameterType.STRING),
            // Opportunity ID of the converted lead
            new Process.PluginDescribeResult.OutputParameter(
                'OpportunityID', 
                Process.PluginDescribeResult.ParameterType.STRING)                
        };

        return result;
    }
        
    /**
     * Implementation of the LeadConvert plug-in.
     * Converts a given lead with several options:
     * leadID - ID of the lead to convert
     * contactID - 
     * accountID - ID of the Account to attach the converted 
     *  Lead/Contact/Opportunity to.
     * convertedStatus - 
     * overWriteLeadSource - 
     * createOpportunity - true if you want to create a new 
     *  Opportunity upon conversion
     * opportunityName - Name of the new Opportunity.
     * sendEmailtoOwner - true if you are changing owners upon 
     *  conversion and want to notify the new Opportunity owner.
     *
     * returns: a Map with the following output:
     * AccountID - ID of the Account created or attached 
     *  to upon conversion.
     * ContactID - ID of the Contact created or attached 
     *  to upon conversion.
     * OpportunityID - ID of the Opportunity created 
     *  upon conversion.
     */
    public Map<String,String> convertLead (
                               String leadID,
                               String contactID,
                               String accountID,
                               String convertedStatus,
                               Boolean overWriteLeadSource,
                               Boolean createOpportunity,
                               String opportunityName,
                               Boolean sendEmailToOwner
        ) {
        Map<String,String> result = new Map<String,String>();
                                
        if (leadId == null) throw new ConvertLeadPluginException(
            'Lead Id cannot be null');
        
        // check for multiple leads with the same ID
        Lead[] leads = [Select Id, FirstName, LastName, Company 
            From Lead where Id = :leadID];
        if (leads.size() > 0) {
            Lead l = leads[0];
            // CheckAccount = true, checkContact = false
            if (accountID == null && l.Company != null) {
                Account[] accounts = [Select Id, Name FROM Account 
                    where Name = :l.Company LIMIT 1];
                if (accounts.size() > 0) {
                    accountId = accounts[0].id;
                }
            }
            
            // Perform the lead conversion.
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadID);
            lc.setOverwriteLeadSource(overWriteLeadSource);
            lc.setDoNotCreateOpportunity(!createOpportunity);
            lc.setConvertedStatus(convertedStatus);
            if (sendEmailToOwner != null) lc.setSendNotificationEmail(
                sendEmailToOwner);
            if (accountId != null && accountId.length() > 0) 
                lc.setAccountId(accountId);
            if (contactId != null && contactId.length() > 0) 
                lc.setContactId(contactId);
            if (createOpportunity) {
                lc.setOpportunityName(opportunityName);
            }
            
            Database.LeadConvertResult lcr = Database.convertLead(
                lc, true);
            if (lcr.isSuccess()) {
                result.put('AccountID', lcr.getAccountId());
                result.put('ContactID', lcr.getContactId());
                if (createOpportunity) {
                    result.put('OpportunityID', 
                        lcr.getOpportunityId());
                }
            } else {
                String error = lcr.getErrors()[0].getMessage();
                throw new ConvertLeadPluginException(error);
            }
        } else { 
            throw new ConvertLeadPluginException(
                'No leads found with Id : "' + leadId + '"');
        }
        return result;
    }
        
    // Utility exception class
    class ConvertLeadPluginException extends Exception {}
}