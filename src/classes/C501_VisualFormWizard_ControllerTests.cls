@istest
class C501_VisualFormWizard_ControllerTests {

    static testmethod void C501_VisualFormWizard_ControllerTest_Error() {

        C501_VisualFormWizard_Controller controller = new C501_VisualFormWizard_Controller();

        // Setup
        controller.getAccount();
        controller.getContact();

        // Code Coverage
        controller.saveOrgSize();
        controller.saveLabels();

        // Check Email
        system.assertEquals(true, C501_VisualFormWizard_Controller.validateEmail('fred@slategravel.org'));
        system.assertEquals(false, C501_VisualFormWizard_Controller.validateEmail('fred%slategravel%org'));

        // Page Reference
        controller.checkUrlParameters();
        controller.getOrgChoice();
        controller.managePeople();
        controller.workDirectly();
        controller.getOrgName();
        controller.getOrgNameNext();
        controller.getOrgSize();
        controller.getOrgSizeNext();
        controller.getOrgLanguage();
        controller.getOrgReach();
        controller.getContactInfo();

        // Update fields
        controller.contact.FirstName = 'firstname';
        controller.contact.LastName = 'lastname';
        controller.contact.email = 'test@test.org';
        controller.contact.C501_VFW_Name__c = 'name';
        controller.contact.C501_VFW_Zipcode__c = '98103';
        controller.contact.C501_VFW_Email__c = 'test@test.org';

        controller.account.name = 'account';

        // Trigger Insert
        controller.save();

        // Trigger Update
        controller.save();
    }    
}