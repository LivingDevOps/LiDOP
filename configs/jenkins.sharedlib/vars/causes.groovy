def setEnvironment(){
 
    def userCause = currentBuild.rawBuild.getCause(Cause.UserIdCause)
    if (userCause != null)
    {   
        def user = userCause.getUserId()
        echo "Set env.USER to " + user
        env.USER = user
    }
    else {
        echo "No USER cause found"
    }
 
    def triggerReasonCause = currentBuild.rawBuild.getCause(hudson.model.Cause$RemoteCause)
    if(triggerReasonCause != null){
        echo "Set env.TRIGGERREASON to " + triggerReasonCause.note
        env.TRIGGERREASON = triggerReasonCause.note
    }
    else {
        echo "No TRIGGERREASON cause"
    }
}