# BlocKraft

**BlocKraft** is a CLI tool designed for organizing `.aia` project files used in MIT App Inventor and its distributions. It helps developers automate the creation of screens, manage reusable components, and handle custom extensions in a structured way.

## Features

- Automates screen and block file generation (`.bky`, `.scm`)
- Organizes project assets, extensions, and reusable components
- Exports `.aia` files ready for MIT App Inventor
- Easy configuration through `blockraft.yaml`

## Requirements

- Dart SDK (>=2.10)
- Dart `yaml` package
- MIT App Inventor for project use

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Horizon3833/BlocKraft.git
   cd BlocKraft
   ```

2. **Install Dependencies:**
   ```bash
   dart pub get
   ```

3. **Set up the Environment:**
   Make sure Dart is properly installed, and the path is set.

## Usage

### 1. Initialize a New Project

You can initialize a new BlocKraft project using the `create` command. This will generate the folder structure, including screens, assets, and more:

```bash
blockraft create my_project
```

### 2. Add a New Screen

To add a new screen to your project, use the following command. It will generate the corresponding `.bky` and `.scm` files:

```bash
blockraft add-screen Screen1
```

### 3. Manage Extensions

BlocKraft can also manage custom extensions in the `extensions/` folder. You can add your custom extensions and they will be packaged automatically:

```bash
blockraft add-extension io_horizon_chess
```

### 4. Build the Project

Once your project is set up, you can build the final `.aia` file for use in MIT App Inventor. This will bundle all screens, assets, and extensions into one `.aia` file:

```bash
blockraft build
```

This will output your project as `blockraft.aia` in the `output/` folder.

### 5. Customize `blockraft.yaml`

Use the `blockraft.yaml` file to configure your project structure. Example configuration:
```yaml
project:
  name: MyProject
  version: 1.0.0

screens:
  include:
    - Home
    - Screen1

assets:
  include:
    - logo.png

extensions:
  enabled:
    io_horizon_chess: true
```

## Folder Structure

```plaintext
blockraft/
│
├── assets/              # Media assets
│   └── logo.png
│
├── extensions/          # Custom extensions
│   └── io_horizon_chess/
│       └── extension.aix
│
├── screens/             # Screen folders
│   ├── Screen1/
│   │   ├── Screen1.bky
│   │   └── Screen1.scm
│
├── shared_components/   # Reusable components
│   ├── Navbar.bky
│   └── Footer.bky
│
├── output/              # Exported files
│   └── blockraft.aia
│
├── blockraft.yaml       # Settings file
└── README.md            # Project documentation
```

## Contribution

Feel free to fork this repository, raise issues, or contribute by submitting pull requests.

