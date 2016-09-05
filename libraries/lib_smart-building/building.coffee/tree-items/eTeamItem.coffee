#
class eTeamItem extends TreeItem
    constructor: ( name = "Team") ->
        super()

        @_name.set name
        
        @add_attr
            send_alert: false
        

    display_suppl_context_actions: ( context_action )  ->
        context_action.push  new TreeAppModule_AddEmployee

    accept_child: ( ch ) ->
        ch instanceof eEmployeeItem