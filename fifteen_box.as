import flash.geom.Point;
import kernel.events.Event;
import caurina.transitions.*;
/**
 * ...
 * @author Rozhin Alexey
 */

class fifteen_box extends MovieClip
{
    private static var TILE_WIDTH:Number = 100;
    private static var TILE_HEIGHT:Number = 100;
    private var _cells_mc:Array;
    
    private var _quad_matrix_size:Number = 10;
    
    private var _ordered_cells:Array;
    private var _history_jumble:Array;
    private var _jumbled_cells:Array;
    
    private var _swap_count:Number = 500; // swap count
    
    private var _empty_cell_point:Point;
    
    private var SwapEmptyCellFunction:Function; 
    private var OnCompleteCellMoveFunction:Function;
    
    public function fifteen_box(assets:MovieClip)
    {
        fscommand("allowscale", "true");
        
        try
        {
            InitBox(assets);
        
        }catch (e:Error)
        {
            _quad_matrix_size = 2;
            InitBox(assets);
        }
    }
    
    private function InitBox(assets:MovieClip): Void
    {
        if (_quad_matrix_size < 2)
        {
            throw new Error("Error: Invalid matrix size. See fifteen_box: InitBox");
        }
        
        SwapEmptyCellFunction = FnA(this, SwapEmptyCell);
        OnCompleteCellMoveFunction = FnA(this, OnCompleteCellMove);
        
        InitStartMatrix(assets);
        JumbleCells(_swap_count);
    }
    
    public static function FnA(target: Object, fn: Function, args: Array): Function
    {
        var result: Function = function(): Object
        {
            return fn.apply(target, arguments.concat(args));
        };
        return result;
    }
    
    private function InitStartMatrix(_assets:MovieClip): Void
    {
        _ordered_cells = new Array();
        _cells_mc = new Array();
        
        var i:Number;
        var j:Number;
        var d:Number = 1;
        
        _assets.bg._width = _quad_matrix_size * TILE_WIDTH;
        _assets.bg._height = _quad_matrix_size * TILE_HEIGHT;
        
        for (i = 0; i < _quad_matrix_size; i++)
        {
            _ordered_cells[i] = new Array();
            _cells_mc[i] = new Array();
            
            for (j = 0; j < _quad_matrix_size; j++)
            {
                _ordered_cells[i][j] = d;
                d++;
                
                if (! ((i == (_quad_matrix_size - 1)) && (j == (_quad_matrix_size - 1))))
                {
                    var tileName:String = 'tile_' + i + '_' + j;
                    _cells_mc[i][j] = _assets.tile_container.attachMovie('Tile', tileName, _assets.tile_container.getNextHighestDepth());
                    _cells_mc[i][j].num_txt.text = _ordered_cells[i][j];
                    _cells_mc[i][j]._x = TILE_WIDTH * j;
                    _cells_mc[i][j]._y = TILE_HEIGHT * i;
                }
            }
        }
        
        _ordered_cells[_quad_matrix_size - 1][_quad_matrix_size - 1] = null;
        _cells_mc[_quad_matrix_size - 1][_quad_matrix_size - 1] = null;
    }
    
    private function JumbleCells(numSwaps:Number): Void
    {
        if (!_jumbled_cells)
        {
            _jumbled_cells = _ordered_cells;
            _empty_cell_point = new Point(_quad_matrix_size - 1, _quad_matrix_size - 1);
        }
        
        SwapEmptyCellFunction(numSwaps);
    }
    
    private function SwapEmptyCell(numSwaps:Number): Void
    {
        trace('=============================');
        trace(numSwaps);
        
        if (numSwaps == 0) return;
        
        var cellPosToSwap:Point = FindSwapCellPosWithEmptiness();
        var tempCellNumber:Number = _jumbled_cells[cellPosToSwap.x][cellPosToSwap.y];
        
        _jumbled_cells[cellPosToSwap.x][cellPosToSwap.y] = _jumbled_cells[_empty_cell_point.x][_empty_cell_point.y];
        _jumbled_cells[_empty_cell_point.x][_empty_cell_point.y] = tempCellNumber;
        
        _priviousEmptyCellPoint = _empty_cell_point;

        ShowCellMove(cellPosToSwap, numSwaps, SwapEmptyCellFunction);
    }
    
    private static var ANIMATION_DURATION:Number = 0.3;
    
    private function ShowCellMove(cellPosition:Point, numSwaps:Number, swapFunction:Function): Void
    {
        var mc:MovieClip = _cells_mc[cellPosition.x][cellPosition.y];
        var emptyCoordX:Number = _empty_cell_point.y * TILE_WIDTH;
        var emptyCoordY:Number = _empty_cell_point.x * TILE_HEIGHT;
        
        Tweener.addTween(mc, { _x: emptyCoordX,
                               _y: emptyCoordY,
                             time: ANIMATION_DURATION,
                       transition:"linear",
                       onComplete: OnCompleteCellMoveFunction,
                       onCompleteParams:[cellPosition, numSwaps, swapFunction]} );
    }
    
    private function OnCompleteCellMove(cellPosToSwap:Point, numSwaps:Number, SwapFunction:Function): Void
    {
        var tempTileMc:MovieClip = _cells_mc[cellPosToSwap.x][cellPosToSwap.y];
        
        _cells_mc[cellPosToSwap.x][cellPosToSwap.y] = _cells_mc[_empty_cell_point.x][_empty_cell_point.y];
        _cells_mc[_empty_cell_point.x][_empty_cell_point.y] = tempTileMc;
        
        _empty_cell_point = cellPosToSwap;
        
        if (!_history_jumble)
        {
            _history_jumble = new Array;
        }
        
        _history_jumble.push([_empty_cell_point, cellPosToSwap]);
        SwapFunction(--numSwaps, _empty_cell_point);
    }
    
    private var _priviousEmptyCellPoint:Point;
    
    private function FindSwapCellPosWithEmptiness(): Point
    {
        var neighbors:Array = new Array();
        
        if (_empty_cell_point.x != 0)
        {
            neighbors.push(new Point(_empty_cell_point.x - 1, _empty_cell_point.y));
        }
        
        if (_empty_cell_point.y != 0)
        {
            neighbors.push(new Point(_empty_cell_point.x, _empty_cell_point.y - 1));
        }
        
        if (_empty_cell_point.x != (_quad_matrix_size - 1))
        {
            neighbors.push(new Point(_empty_cell_point.x + 1, _empty_cell_point.y));
        }
        
          if (_empty_cell_point.y != (_quad_matrix_size - 1))
        {
            neighbors.push(new Point(_empty_cell_point.x, _empty_cell_point.y + 1));
        }
        
        var rndIndex:Number = FindRandomIndex(neighbors.length);
        
        var regenerateRandomIndex:Boolean = neighbors[rndIndex].equals(_priviousEmptyCellPoint);
                                            
        
        while (regenerateRandomIndex)
        {
            rndIndex = FindRandomIndex(neighbors.length);
            regenerateRandomIndex = neighbors[rndIndex].equals(_priviousEmptyCellPoint);
        }
        
        return neighbors[rndIndex];
    }
    
    private function FindRandomIndex(arrayLength:Number): Number
    {
        var directionRand:Boolean = Math.random() > 0.5 ? true:false;
        
        var rndIndex:Number;
        
        if (directionRand)
        {
            rndIndex = Math.floor(Math.random() * (arrayLength - 1));
        }else 
        {
            rndIndex = Math.ceil(Math.random() * (arrayLength - 1));
        }
        
        return rndIndex;
    }
}