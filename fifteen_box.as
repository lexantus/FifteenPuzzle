import flash.geom.Point;
/**
 * ...
 * @author Rozhin Alexey
 */

class fifteen_box extends MovieClip
{
    private var _quad_matrix_size:Number;
    
    private var _ordered_cells:Array;
    private var _history_jumble:Array;
    private var _jumbled_cells:Array;
    
    private var k:Number = 4; // quadratic matrix size
    private var n:Number = 100; // swap count
    
    private var _empty_cell_point:Point;
    
    public function fifteen_box(): Void
    {
        InitBox();
    }
    
    private function InitBox(): Void
    {
        if (_quadMatrixSize < 2)
        {
            throw new Error("Error: Invalid matrix size. See fifteen_box: InitBox");
        }
        
        InitStartMatrix();
        JumbleCells(n);
    }
    
    private function InitStartMatrix(): Void
    {
        _ordered_cells = new Array;
        
        var i:Number;
        var j:Number;
        
        for (i = 0; i < _quadMatrixSize; i++)
        {
            _ordered_cells[i] = new Array;
            
            for (j = 0; j < (_quadMatrixSize - 1); j++)
            {
                _ordered_cells[i][j] = (i + 1) * (j + 1);
            }
        }
        
        _ordered_cells[_quadMatrixSize - 1][_quadMatrixSize - 1] = null;
    }
    
    private function JumbleCells(numSwaps:Number): Void
    {
        if (!_jumbled_cells)
        {
            _jumbled_cells = _ordered_cells;
            _empty_cell_point = new Point(_quadMatrixSize - 1, _quadMatrixSize - 1);
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
        _empty_cell_point = cellPosToSwap;
        var tempCell:MovieClip = _jumbled_cells[cellPosToSwap.x][cellPosToSwap.y];
        _jumbled_cells[cellPosToSwap.x][cellPosToSwap.y] = _jumbled_cells[_empty_cell_point.x][_empty_cell_point.y];
        _jumbled_cells[_empty_cell_point.x][_empty_cell_point.y] = tempCell;
        
        if (!_history_jumble)
        {
            _history_jumble = new Array;
        }
        
        _history_jumble.push([_empty_cell_point, cellPosToSwap]);
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
        
        var numNeighbors:Number = neighbors;
        var rndIndex:Number = Math.ceil(Math.random() * (numNeighbors - 1));
        
        return neighbors[rndIndex];
    }
}