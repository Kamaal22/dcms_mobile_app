return Scaffold(
      body: IndexedStack(children: _pages, index: _currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.blue[300],
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: navigateToPage,
        items: [
          BottomNavigationBarItem(
            tooltip: "Home",
            icon: _currentIndex == 0
                ? Center(
                    child: FaIcon(
                      FontAwesomeIcons.house,
                      size: 22,
                      color: Colors.blue[800],
                    ),
                  )
                : FaIcon(
                    FontAwesomeIcons.house,
                    size: 22,
                  ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            tooltip: "Appointment",
            icon: _currentIndex == 1
                ? Ink(
                    height: 40,
                    width: 40,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 22,
                        color: Colors.blue[800],
                      ),
                    ),
                  )
                : FaIcon(
                    FontAwesomeIcons.plus,
                    size: 22,
                  ),
            label: 'Add Appointment',
          ),
          BottomNavigationBarItem(
            tooltip: "Appointments",
            icon: _currentIndex == 2
                ? Ink(
                    height: 40,
                    width: 40,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.calendar,
                        size: 22,
                        color: Colors.blue[800],
                      ),
                    ),
                  )
                : FaIcon(
                    FontAwesomeIcons.calendar,
                    size: 22,
                  ),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            tooltip: "Settings",
            icon: _currentIndex == 3
                ? Ink(
                    height: 40,
                    width: 40,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.gear,
                        size: 22,
                        color: Colors.blue[800],
                      ),
                    ),
                  )
                : FaIcon(
                    FontAwesomeIcons.gear,
                    size: 22,
                  ),
            label: 'Settings',
          ),
        ],
      ),
    );