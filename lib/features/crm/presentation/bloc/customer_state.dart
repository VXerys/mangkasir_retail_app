import '../../domain/entities/customer.dart';

sealed class CustomerState {
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomerLoaded extends CustomerState {
  const CustomerLoaded(this.customers);
  final List<Customer> customers;
}

class CustomerSaving extends CustomerState {
  const CustomerSaving();
}

class CustomerError extends CustomerState {
  const CustomerError(this.message);
  final String message;
}
