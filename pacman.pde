class PacmanType {
  int _gridSize;
  int _x;
  int _y; 
  int _speed;
  int _moveX, _moveY;
  int _dir;
  float _mouth, _mouthSize;
  int _counter, _size;

  PacmanType(int col, int row, int gridSize) {
    // sizes
    _gridSize = gridSize;
    // where is pacman?
    _x = col * gridSize;
    _y = row * gridSize;
    _dir = 0; // right
    // default movement
    _speed = gridSize / 10;
    _moveRight();
    // what does pacman look like?
    _mouth = 0;
    _mouthSize = PI/4;
    _size = gridSize * 9 / 10;
  }
  void draw() {
    strokeWeight(5);
    fill(255, 255, 0);
    // Circle draws clockwise..?    stroke(0);
    arc(_x + _gridSize / 2, _y + _gridSize / 2, _size, _size, _mouth + _mouthSize / 2, _mouth + 2*PI - _mouthSize / 2, PIE);
    //fill(0);
    //rect(_x - 5, _y - 5, 10, 10);
  }
  void update() {
    ++_counter;

    boolean isOnGrid = ((_x % _gridSize) == 0 && (_y % _gridSize) == 0);

    if (isOnGrid) {
      switch (_dir) {
      case 0:
        _moveRight();
        break;
      case 1:
        _moveUp();
        break;
      case 2:
        _moveLeft();
        break;
      case 3:
        _moveDown();
        break;
      }

      if ((_moveX != 0 || _moveY != 0)) {
        int row = (_y / _gridSize);
        int col = (_x / _gridSize);
        int newRow = row + _moveY; // must be in [-1, 0, 1]
        int newCol = col + _moveX; // must be in [-1, 0, 1]
        if (maze.isWall(newRow, newCol)) {
          _moveX = 0;
          _moveY = 0;
        }
      }
    }

    // update position
    _x += _moveX * _speed;
    _y += _moveY * _speed;

    // update mouth
    if ((_counter % 10) == 0) {
      if (_mouthSize >= PI/4) {
        _mouthSize = 0;
      } else {
        _mouthSize = PI/4;
      }
    }
  }
  void moveLeft() {
    _dir = 2;
  }
  void _moveLeft() {
    _moveX = -1;
    _moveY = 0;
    _mouth = PI;
  }
  void moveRight() {
    _dir = 0;
  }
  void _moveRight() {
    _moveX = 1;
    _moveY = 0;
    _mouth = 0;
  }
  void moveUp() {
    _dir = 1;
  }
  void _moveUp() {
    _moveX = 0;
    _moveY = -1;
    _mouth = -PI/2;
  }
  void moveDown() {
    _dir = 3;
  }
  void _moveDown() {
    _moveX = 0;
    _moveY = 1;
    _mouth = PI/2;
  }
}

class MazeType {
  static final int BIG_FOOD = 3;
  static final int FOOD = 2;
  static final int WALL = 1;
  static final int VOID = 0;
  int _data[][];
  int _gridSize;

  MazeType(int data[][], int gridSize) {
    _data = data;
    _gridSize = gridSize;
  }
  boolean isWall(int row, int col) {
    return _getObject(row, col) == WALL;
  }
  boolean isFood(int row, int col) {
    return _getObject(row, col) == FOOD;
  }
  int _getObject(int row, int col) {
    if ((row < 0 || row >= _data.length) ||
      (col < 0 || col >= _data[row].length)) {
      return WALL;
    }
    return _data[row][col];
  }
  void draw() {
    for (int row = 0; row < _data.length; ++row) {
      for (int col = 0; col < _data[row].length; ++col) {
        int x = col * _gridSize;
        int y = row * _gridSize;
        switch (_data[row][col]) {
        case WALL:
          noStroke();
          fill(0, 0, 254);
          rect(x, y, _gridSize, _gridSize);
          break;
        case FOOD:
          fill(#E8F743);
          stroke(#E8F743);
          circle(x + _gridSize / 2, y + _gridSize / 2, _gridSize / 10);
          break;
        case BIG_FOOD:
          fill(#E8F743);
          stroke(#E8F743);
          circle(x + _gridSize / 2, y + _gridSize / 2, _gridSize / 5);
          break;
        }
      }
    }
  }
}  

class MazeConstructor {
  final int _gridSize = 50;
  PacmanType pacman;
  MazeType maze;

  MazeConstructor() {
    String repr[] = {
      //12345678911131517
      "XXXXXXXXXXXXXXXXX", // 1
      "XfffffffXfffffffX", // 2
      "XfXfXfXfffXfXfXfX", // 3
      "XfXfffXXfXXfffXfX", // 4
      "XfffXfXfffXfXfffX", // 5
      "XXXfXfffXfffXfXXX", // 6
      "XfffXfXfffXfXfffX", // 7
      "XfXfffXXfXXfffXfX", // 8
      "XfXfXfXf^fXfXfXfX", // 9
      "XfffffffXfffffffX", // 10
      "XXXXXXXXXXXXXXXXX", // 11
    };

    int data[][] = new int[repr.length][];
    for (int row = 0; row < repr.length; ++row) {
      String sourceRow = repr[row];
      data[row] = new int[sourceRow.length()];
      for (int col = 0; col < sourceRow.length(); ++col) {
        switch (sourceRow.charAt(col)) {
        case 'X':
          data[row][col] = MazeType.WALL;
          break;
        case 'f':
          data[row][col] = MazeType.FOOD;
          break;
        case 'F':
          data[row][col] = MazeType.BIG_FOOD;
          break;
        case '^':
          if (pacman != null) {
            throw new RuntimeException("already have a pacman");
          }
          pacman = new PacmanType(row, col, _gridSize);
          pacman.moveUp();
        case ' ':
        default:
          data[row][col] = MazeType.VOID;
        }
      }
    }

    maze = new MazeType(data, _gridSize);
    if (maze == null || pacman == null) {
      throw new RuntimeException("missing maze or pacman");
    }
  }
}


MazeType maze;
PacmanType pacman;

void setup() {
  fullScreen();
  //size(800, 800);
  MazeConstructor mc = new MazeConstructor();
  pacman = mc.pacman;
  maze = mc.maze;
}

void draw() {
  background(255);
  pacman.update();
  maze.draw();
  pacman.draw();
}

void keyPressed() {
  switch (key == CODED ? keyCode : key) {
  case UP:
    pacman.moveUp();
    println("up");
    break;
  case DOWN:
    pacman.moveDown();
    println("down");
    break;
  case LEFT:
    pacman.moveLeft();
    println("left");
    break;
  case RIGHT:
    pacman.moveRight();
    println("right");
    break;
  case 'q':
    exit();
  }
}
