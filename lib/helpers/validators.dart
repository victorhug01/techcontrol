mixin ValidationMixinClass {
  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validations = func();
      if (validations != null) return validations;
    }
    return null;
  }

  String? isNotEmpyt(String? value, [String? message]) {
    if (value == null ||value.isEmpty) return message ?? "Campo em Branco!";
    return null;
  }

  String? hasSixChars(String? value, [String? message]) {
    if (value!.length < 6) return message ?? "Você tem que usar 6 caracteres!";
    return null;
  }

  String? maxTwoHundredCharacters(String? value, [String? message]){
    if(value!.length >= 200) return message ?? "O máximo de caracteres é 200";
    return null;
  }

  String? isNumber(String? value, [String? message]) {
    if (value == null || num.tryParse(value) == null) return message ?? "Somente números";
    return null;
  }

  String? isValidCPF(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return message ?? "CPF inválido";
    }

    // Remove caracteres não numéricos (se houver)
    value = value.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CPF tem exatamente 11 dígitos
    if (value.length != 11) {
      return message ?? "CPF inválido";
    }

    // Verifica se o CPF não é uma sequência de números repetidos (exemplo: 11111111111)
    if (RegExp(r'(\d)\1{10}').hasMatch(value)) {
      return message ?? "CPF inválido";
    }

    // Validação do primeiro dígito
    int sum1 = 0;
    for (int i = 0; i < 9; i++) {
      sum1 += int.parse(value[i]) * (10 - i);
    }
    int remainder1 = sum1 % 11;
    int digit1 = remainder1 < 2 ? 0 : 11 - remainder1;

    // Validação do segundo dígito
    int sum2 = 0;
    for (int i = 0; i < 10; i++) {
      sum2 += int.parse(value[i]) * (11 - i);
    }
    int remainder2 = sum2 % 11;
    int digit2 = remainder2 < 2 ? 0 : 11 - remainder2;

    // Compara os dois últimos dígitos com os calculados
    if (digit1.toString() != value[9] || digit2.toString() != value[10]) {
      return message ?? "CPF inválido";
    }

    return null; // CPF válido
  }
}