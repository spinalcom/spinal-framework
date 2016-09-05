
#
class MoveButtons extends Model
    constructor: () ->
        super()

        @add_attr
            step: new Val
            _up: new Bool
            _down: new Bool
            val: new Val

