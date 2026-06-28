import '../models/stylist.dart';
import '../models/booking.dart';
import '../models/service_request.dart';
import '../models/booking_status.dart';

final List<Stylist> mockStylists = [
  const Stylist(
    id: 1,
    name: 'Isabela Moura',
    specialty: 'Consultoria de Estilo',
    rating: 4.9,
    reviews: 87,
    initials: 'IM',
    tags: ['Looks Casuais', 'Eventos'],
    bio:
        'Estilista profissional com mais de 8 anos de experiência em consultoria '
        'de imagem e moda. Especializada em criar looks únicos para cada cliente.',
    services: [
      {'name': 'Consultoria de Estilo', 'price': 'R\$ 200'},
      {'name': 'Montagem de Look',      'price': 'R\$ 150'},
      {'name': 'Personal Shopper',      'price': 'R\$ 300'},
      {'name': 'Look para Evento',      'price': 'R\$ 250'},
    ],
    isFavorite: true,
  ),
  const Stylist(
    id: 2,
    name: 'Rafael Duarte',
    specialty: 'Criação de Peças Sob Medida',
    rating: 4.8,
    reviews: 63,
    initials: 'RD',
    tags: ['Alta Costura', 'Casamentos'],
    bio:
        'Especialista em alta costura e criação de peças exclusivas. '
        'Atende noivas e clientes em busca de peças únicas e personalizadas.',
    services: [
      {'name': 'Peça Sob Medida',       'price': 'R\$ 800'},
      {'name': 'Consultoria de Estilo', 'price': 'R\$ 200'},
      {'name': 'Look para Casamento',   'price': 'R\$ 500'},
    ],
    isFavorite: false,
  ),
  const Stylist(
    id: 3,
    name: 'Camila Vaz',
    specialty: 'Montagem de Looks',
    rating: 4.7,
    reviews: 42,
    initials: 'CV',
    tags: ['Corporativo', 'Tendências'],
    bio:
        'Especializada em looks corporativos e tendências de moda. '
        'Ajuda profissionais a construírem uma imagem sólida e alinhada com suas metas.',
    services: [
      {'name': 'Look Corporativo',       'price': 'R\$ 180'},
      {'name': 'Montagem de Look',       'price': 'R\$ 150'},
      {'name': 'Consultoria de Imagem',  'price': 'R\$ 250'},
    ],
    isFavorite: true,
  ),
];

final List<Booking> mockBookings = [
  const Booking(
    id: 1,
    stylist: 'Isabela Moura',
    stylistInitials: 'IM',
    service: 'Consultoria de Estilo',
    date: '20/06/2025',
    time: '14:00',
    status: BookingStatus.accepted,
    address: 'Rua das Flores, 123 - Savassi, Belo Horizonte',
    price: 'R\$ 200',
    notes: 'Levar peças favoritas do guarda-roupa para análise durante a consultoria.',
  ),
  const Booking(
    id: 2,
    stylist: 'Rafael Duarte',
    stylistInitials: 'RD',
    service: 'Criação de Peças',
    date: '25/06/2025',
    time: '10:00',
    status: BookingStatus.pending,
    address: 'Atelier Rafael Duarte - Lourdes, Belo Horizonte',
    price: 'R\$ 800',
    notes: 'Aguardando confirmação do estilista.',
  ),
  const Booking(
    id: 3,
    stylist: 'Camila Vaz',
    stylistInitials: 'CV',
    service: 'Montagem de Look',
    date: '10/06/2025',
    time: '16:00',
    status: BookingStatus.done,
    address: 'Estúdio Camila Vaz - Funcionários, Belo Horizonte',
    price: 'R\$ 150',
    notes: 'Atendimento concluído com sucesso.',
  ),
];

List<ServiceRequest> mockRequests = [
  ServiceRequest(
    id: 1,
    client: 'Mariana Silva',
    clientInitials: 'MS',
    service: 'Consultoria de Estilo',
    date: '20/06/2025',
    time: '14:00',
    description: 'Preciso de ajuda para montar looks para viagem de trabalho.',
    status: BookingStatus.pending,
  ),
  ServiceRequest(
    id: 2,
    client: 'João Pereira',
    clientInitials: 'JP',
    service: 'Montagem de Look para Evento',
    date: '22/06/2025',
    time: '11:00',
    description: 'Tenho um casamento e quero um look elegante e moderno.',
    status: BookingStatus.pending,
  ),
  ServiceRequest(
    id: 3,
    client: 'Ana Costa',
    clientInitials: 'AC',
    service: 'Criação de Peça Sob Medida',
    date: '28/06/2025',
    time: '09:00',
    description: 'Quero criar um vestido para formatura.',
    status: BookingStatus.accepted,
  ),
  ServiceRequest(
    id: 4,
    client: 'Lucas Mendes',
    clientInitials: 'LM',
    service: 'Consultoria Completa',
    date: '05/06/2025',
    time: '15:00',
    description: 'Reformulação completa do guarda-roupa.',
    status: BookingStatus.done,
  ),
];
