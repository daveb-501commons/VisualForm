public with sharing class VisualFormWizardController {

    public String managePeople { get; set;}
                               
    Contact contact;
    public Contact getContact() {
      if(contact == null) contact = new Contact();
      return contact;
   }

   public PageReference step1() {
      return Page.VisualFormWizard;
   }

   public PageReference step2() {
      return Page.VisualFormWizardStep2;
   }

   public PageReference step3() {
      return Page.VisualFormWizardStep3;
   }

   // This method performs the final save for all four objects, and  
   // then navigates the user to the detail page for the new  
   // opportunity.  
   public PageReference save() {

      insert contact;

      // Finally, send the user to the detail page for  
      // the new opportunity.  
      // Note that using '/' in the new PageReference object keeps  
      // the user in the current instance of salesforce, rather than  
      // redirecting him or her elsewhere.  
      PageReference redirectPage = new PageReference('https://www.google.com');
      redirectPage.setRedirect(true);

      return redirectPage;
   }

}