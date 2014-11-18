import flash.geom.Point;
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
    
    private var _n:Number = 100; // swap count
    
    private var _empty_cell_point:Point;
    
    public function fifteen_box(assets:MovieClip)
    {
        trace("fifteen_box: fifteen_box: ");
        fscommand("allowscale", "true");
        InitBox(assets);
    }
    
    private function InitBox(assets:MovieClip): Void
    {
        if (_quad_matrix_size < 2)
        {
            throw new Error("Error: Invalid matrix size. See fifteen_box: InitBox");
        }
        
        InitStartMatrix(assets);
        JumbleCells(_n);
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
    }
    
    private function JumbleCells(numSwaps:Number): Void
    {
        if (!_jumbled_cells)
        {
            _jumbled_cells = _ordered_cells;
            _empty_cell_point = new Point(_quad_matrix_size - 1, _quad_matrix_size - 1);
        }
        
        var i:Number;
        
        for (i = 0; i < numSwaps; i++)
        {
            SwapEmptyCell();
        }
    }
    
    private function SwapEmptyCell(): Void
    {
        var cellPosToSwap:Point = FindSwapCellPosWithEmptiness();
        var tempCell:MovieClip = _jumbled_cells[cellPosToSwap.x][cellPosToSwap.y];
        _jumbled_cells[cellPosToSwap.x][cellPosToSwap.y] = _jumbled_cells[_empty_cell_point.x][_empty_cell_point.y];
        _jumbled_cells[_empty_cell_point.x][_empty_cell_point.y] = tempCell;
        
        if (!_history_jumble)
        {
            _history_jumble = new Array;
        }
        
        _history_jumble.push([_empty_cell_point, cellPosToSwap]);
        _empty_cell_point = cellPosToSwap;
    }
    
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
        
        var numNeighbors:Number = neighbors.length;
        var rndIndex:Number = Math.ceil(Math.random() * (numNeighbors - 1));
        
        return neighbors[rndIndex];
    }
}