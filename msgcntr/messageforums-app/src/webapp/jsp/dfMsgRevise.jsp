<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://sakaiproject.org/jsf2/sakai" prefix="sakai" %>
<jsp:useBean id="msgs" class="org.sakaiproject.util.ResourceLoader" scope="session">
   <jsp:setProperty name="msgs" property="baseName" value="org.sakaiproject.api.app.messagecenter.bundle.Messages"/>
</jsp:useBean>

<f:view>
  <sakai:view_container title="#{msgs.cdfm_revise_forum_msg}">
    <sakai:view_content>
<!--jsp/dfMsgRevise.jsp-->
	<h:form id="dfCompose">
		<f:verbatim><input type="hidden" id="currentMessageId" name="currentMessageId" value="</f:verbatim><h:outputText value="#{ForumTool.selectedMessage.message.id}"/><f:verbatim>"/></f:verbatim>
		<f:verbatim><input type="hidden" id="currentTopicId" name="currentTopicId" value="</f:verbatim><h:outputText value="#{ForumTool.selectedTopic.topic.id}"/><f:verbatim>"/></f:verbatim>
		<f:verbatim><input type="hidden" id="currentForumId" name="currentForumId" value="</f:verbatim><h:outputText value="#{ForumTool.selectedForum.forum.id}"/><f:verbatim>"/></f:verbatim>
			<style type="text/css">
				@import url("/messageforums-tool/css/msgcntr.css");
			</style>
            <script>includeLatestJQuery("msgcntr");</script>
       		<script src="/messageforums-tool/js/sak-10625.js"></script>
       		<script src="/messageforums-tool/js/forum.js"></script>
			<script src="/messageforums-tool/js/messages.js"></script>
        <script>
            $(document).ready(function () {
                var menuLink = $('#forumsMainMenuLink');
                var menuLinkSpan = menuLink.closest('span');
                menuLinkSpan.addClass('current');
                menuLinkSpan.html(menuLink.text());
            });
        </script>
        <%@ include file="/jsp/discussionForum/menu/forumsMenu.jsp" %>
     <h3><h:outputText value="#{msgs.cdfm_revise_forum_msg}" /></h3>

			<table class="topicBloc topicBlocLone">
				<tr>
					<td>
						<span class ="title">
							<h:outputText value="#{ForumTool.selectedForum.forum.title}-#{ForumTool.selectedTopic.topic.title}" />
						</span>
						<p class="textPanel">
	 <h:outputText value="#{ForumTool.selectedTopic.topic.shortDescription}"/>
						</p>
					</td>
				</tr>
			</table>	

	<p class="instruction">		
              <h:outputText value="#{msgs.cdfm_required}"/>
              <h:outputText value="#{msgs.cdfm_info_required_sign}" styleClass="reqStarInline" />
	  </p>
		<h:messages styleClass="alertMessage" id="errorMessages" rendered="#{! empty facesContext.maximumSeverity}"/>
		<h:panelGrid styleClass="jsfFormTable" columns="1" style="width: 100%;">
			<h:panelGroup>
				<h:outputLabel for="df_compose_title" style="display:block;float:none;clear:both;padding-bottom:.3em">
							     <h:outputText value="#{msgs.cdfm_info_required_sign}" styleClass="reqStar"/>
					<h:outputText value="#{msgs.cdfm_title}" />
				</h:outputLabel>
					   <h:inputText value="#{ForumTool.composeTitle}" size="40" required="true" id="df_compose_title">
						 <f:validator validatorId="MessageTitle" />
						 <f:validateLength minimum="1" maximum="255"/>
					   </h:inputText>
				   </h:panelGroup>
		</h:panelGrid>



	            <h:outputText value="#{msgs.cdfm_message}" />

	            <sakai:inputRichText textareaOnly="#{PrivateMessagesTool.mobileSession}" value="#{ForumTool.composeBody}" id="df_compose_body" rows="#{ForumTool.editorRows}" cols="132">
				</sakai:inputRichText>
<%--********************* Attachment *********************--%>	
	        <h4>
	          <h:outputText value="#{msgs.cdfm_att}"/>
	        </h4>

			<p class="instruction">
	        <h:outputText value="#{msgs.cdfm_no_attachments}" rendered="#{empty ForumTool.attachments}"/>
			</p>
			
	
			<%-- designNote: moved rendered attribute from h:colun to dataTable - we do not want empty tables--%>
			<h:dataTable styleClass="attachPanel" id="attmsg" width="100%" value="#{ForumTool.attachments}" var="eachAttach"
					columnClasses="att,bogus,itemAction specialLink,bogus,bogus" rendered="#{!empty ForumTool.attachments}" style="width:auto">
					  <h:column>
							<f:facet name="header">
							</f:facet>
							<sakai:contentTypeMap fileType="#{eachAttach.attachment.attachmentType}" mapType="image" var="imagePath" pathPrefix="/library/image/"/>									
							<h:graphicImage id="exampleFileIcon" value="#{imagePath}" />								
							</h:column>	
							<h:column>
							<f:facet name="header">
								<h:outputText value="#{msgs.cdfm_title}"/>
							</f:facet>
							<h:outputText value="#{eachAttach.attachment.attachmentName}"/>
							</h:column>
							<h:column>
								<h:commandLink action="#{ForumTool.processDeleteAttachRevise}" 
									immediate="true"
									onfocus="document.forms[0].onsubmit();"
									title="#{msgs.cdfm_remove}">
									<h:outputText value="#{msgs.cdfm_remove}"/>
<%--									<f:param value="#{eachAttach.attachmentId}" name="dfmsg_current_attach"/>--%>
									<f:param value="#{eachAttach.attachment.attachmentId}" name="dfmsg_current_attach"/>
								</h:commandLink>
						</h:column>
					  <h:column>
							<f:facet name="header">
								<h:outputText value="#{msgs.cdfm_attsize}" />
							</f:facet>
							<h:outputText value="#{eachAttach.attachment.attachmentSize}"/>
						</h:column>
					  <h:column>
							<f:facet name="header">
		  			    <h:outputText value="#{msgs.cdfm_atttype}" />
							</f:facet>
							<h:outputText value="#{eachAttach.attachment.attachmentType}"/>
						</h:column>
						</h:dataTable>   

			<p style="padding:0" class="act">
				<h:commandButton 
					rendered="#{empty ForumTool.attachments && empty facesContext.maximumSeverity}"
						action="#{ForumTool.processAddAttachmentRedirect}" 
						value="#{msgs.cdfm_button_bar_add_attachment_redirect}" 
						accesskey="a" 
						style="font-size:95%"/>
				<h:commandButton
					rendered="#{not empty ForumTool.attachments && empty facesContext.maximumSeverity}"
						action="#{ForumTool.processAddAttachmentRedirect}"
						value="#{msgs.cdfm_button_bar_add_attachment_more_redirect}"
						accesskey="a"
						style="font-size:95%"/>
			 </p>
        		
			
<%--********************* Label *********************
				<sakai:panel_titled>
          <table width="80%" align="left">
            <tr>
              <td align="left" width="20%">
                <h:outputText value="Label"/>
              </td>
              <td align="left">
 							  <h:selectOneListbox size="1" id="viewlist">
            		  <f:selectItem itemLabel="Normal" itemValue="none"/>
          			</h:selectOneListbox>  
              </td>                           
            </tr>                                
          </table>
        </sakai:panel_titled>
--%>		        
      <p style="padding:0" class="act">
        <h:commandButton action="#{ForumTool.processDfMsgRevisedPost}" value="#{msgs.cdfm_button_bar_post_revised_msg}" rendered="#{empty facesContext.maximumSeverity}" accesskey="s" styleClass="active blockMeOnClick" />
        <h:commandButton action="#{ForumTool.processDfMsgRevisedCancel}" value="#{msgs.cdfm_button_bar_cancel}"  accesskey="x" />
        <h:outputText styleClass="sak-banner-info" style="display:none" value="#{msgs.cdfm_processing_submit_message}" />
      </p>
    </h:form>
     
    </sakai:view_content>
  </sakai:view_container>
</f:view> 

