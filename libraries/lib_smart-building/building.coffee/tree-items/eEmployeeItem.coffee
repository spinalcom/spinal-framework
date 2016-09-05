#
class eEmployeeItem extends TreeItem
    constructor: ( params = {} ) ->
        super()
        
        if params.name? then @_name.set params.name else @_name.set "Unknown Guy"

        @add_attr
            name: @_name
            id: if params.id? then params.id else "0"
            phone: if params.phone? then params.phone else "+336123456780"
            role: new Choice( 0, ["directrice","operateur","technicien"] )

        if params.role? then @role.num.set params.role

