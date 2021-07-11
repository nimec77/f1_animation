class Driver {
  Driver({
    required this.firstName,
    required this.lastName,
    required this.driverNumber,
    required this.team,
    required this.nationality,
    required this.image,
  });

  String firstName;
  String lastName;
  int driverNumber;
  String team;
  String nationality;
  String image;
}

enum StringType { firstName, lastName, team }

List<Driver> drivers = [
  Driver(
    firstName: 'Lewis',
    lastName: 'Hamilton',
    driverNumber: 44,
    team: 'Mercedes',
    nationality: 'uk',
    image: 'lewis',
  ),
  Driver(
    firstName: 'Sebastian',
    lastName: 'Vettel',
    driverNumber: 5,
    team: 'Ferrari',
    nationality: 'de',
    image: 'seb',
  ),
  Driver(
    firstName: 'Max',
    lastName: 'Verstappen',
    driverNumber: 33,
    team: 'Red Bull Racing',
    nationality: 'nl',
    image: 'max',
  ),
  Driver(
    firstName: 'Daniel',
    lastName: 'Ricardo',
    driverNumber: 3,
    team: 'Renault',
    nationality: 'au',
    image: 'dan',
  ),
  Driver(
    firstName: 'Kimi',
    lastName: 'Raikkonen',
    driverNumber: 7,
    team: 'Alfa Romeo',
    nationality: 'fi',
    image: 'kim',
  )
];
