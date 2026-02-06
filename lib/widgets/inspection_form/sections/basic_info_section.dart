// lib/widgets/inspection_form/sections/basic_info_section.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../providers/basic_info_provider.dart';
import '../../../services/user_service.dart';
import '../../../services/auth_service.dart';
import '../shared/section_card.dart';

class BasicInfoSection extends ConsumerStatefulWidget {
  const BasicInfoSection({super.key});

  @override
  ConsumerState<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends ConsumerState<BasicInfoSection> {
  final Map<String, String> _stateMapping = {
    'New Hampshire': 'NH',
    'Vermont': 'VT',
    'Maine': 'ME',
  };
  List<Map<String, dynamic>> _municipalities = [];
  List<String> _filteredCities = [];
  bool _isCitiesLoading = false;
  
  // User/Inspector related state
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _inspectors = [];
  bool _isInspectorsLoading = false;
  String? _inspectorsError;
  
  // Inspection number options based on frequency
  List<String> _inspectionNumberOptions = [];

  @override
  void initState() {
    super.initState();
    _loadMunicipalities();
    _loadInspectors();
  }

  Future<void> _loadMunicipalities() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/municipalities_dropdown.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _municipalities = jsonData.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load city data: $e')),
        );
      }
    }
  }

  Future<void> _loadInspectors() async {
    setState(() {
      _isInspectorsLoading = true;
      _inspectorsError = null;
    });

    try {
      final users = await _userService.fetchUsers();
      setState(() {
        _inspectors = users;
        _isInspectorsLoading = false;
      });
      
      // Set default inspector to logged-in user if available
      final notifier = ref.read(basicInfoProvider.notifier);
      final basicInfo = ref.read(basicInfoProvider);
      
      // Only set default if inspector is not already set
      if (basicInfo.inspector.isEmpty) {
        final authService = AuthService();
        final loggedInUserName = await authService.getUserName();
        
        if (loggedInUserName != null) {
          // Check if the logged-in user is in the inspectors list
          final matchingUser = users.firstWhere(
            (user) => user['name'] == loggedInUserName,
            orElse: () => {},
          );
          
          if (matchingUser.isNotEmpty) {
            notifier.updateInspector(loggedInUserName);
          }
        }
      }
    } catch (e) {
      setState(() {
        _isInspectorsLoading = false;
        _inspectorsError = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load inspectors: $e')),
        );
      }
    }
  }

  void _filterCitiesByState(String? selectedState) {
    if (selectedState == null || _municipalities.isEmpty) {
      setState(() {
        _filteredCities = [];
      });
      return;
    }

    setState(() {
      _isCitiesLoading = true;
    });

    final stateAbbr = _stateMapping[selectedState];
    if (stateAbbr == null) {
      setState(() {
        _filteredCities = [];
        _isCitiesLoading = false;
      });
      return;
    }

    final citiesForState = _municipalities
        .where((municipality) => municipality['state'] == stateAbbr)
        .map<String>((municipality) => municipality['name'] as String)
        .toList();

    citiesForState.sort();

    setState(() {
      _filteredCities = citiesForState;
      _isCitiesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final basicInfo = ref.watch(basicInfoProvider);
    final notifier = ref.read(basicInfoProvider.notifier);

    return SectionCard(
      title: 'Basic Information',
      icon: Icons.info,
      children: [
        // Location
        TextFormField(
          initialValue: basicInfo.location,
          decoration: const InputDecoration(
            labelText: 'Location *',
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.updateLocation,
        ),
        const SizedBox(height: 16),

        // Location Street
        TextFormField(
          initialValue: basicInfo.locationStreet,
          decoration: const InputDecoration(
            labelText: 'Location Street',
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.updateLocationStreet,
        ),
        const SizedBox(height: 16),

        // State Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'State *',
            border: OutlineInputBorder(),
          ),
          value: basicInfo.locationState.isEmpty ? null : basicInfo.locationState,
          items: const [
            DropdownMenuItem(value: 'New Hampshire', child: Text('New Hampshire')),
            DropdownMenuItem(value: 'Vermont', child: Text('Vermont')),
            DropdownMenuItem(value: 'Maine', child: Text('Maine')),
          ],
          onChanged: (value) {
            if (value != null) {
              notifier.updateLocationState(value);
              notifier.updateLocationCity(''); // Clear city when state changes
              _filterCitiesByState(value);
            }
          },
        ),
        const SizedBox(height: 16),

        // City Dropdown
        DropdownSearch<String>(
          items: (filter, infiniteScrollProps) {
            if (filter.isNotEmpty) {
              return _filteredCities
                  .where((city) => city.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            }
            return _filteredCities;
          },
          selectedItem: basicInfo.locationCity.isEmpty ? null : basicInfo.locationCity,
          enabled: basicInfo.locationState.isNotEmpty && !_isCitiesLoading,
          onChanged: (value) {
            if (value != null) notifier.updateLocationCity(value);
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'City *',
              border: const OutlineInputBorder(),
              enabled: basicInfo.locationState.isNotEmpty && !_isCitiesLoading,
              suffixIcon: basicInfo.locationState.isEmpty
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : _isCitiesLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            searchFieldProps: const TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search cities...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(color: selectedItem == null ? Colors.grey[600] : null),
            );
          },
        ),
        const SizedBox(height: 16),

        // Date Picker
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: basicInfo.date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              notifier.updateDate(date);
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date *',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(DateFormat('yyyy-MM-dd').format(basicInfo.date)),
          ),
        ),
        const SizedBox(height: 16),

        // Inspector Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Inspector *',
            border: const OutlineInputBorder(),
            suffixIcon: _isInspectorsLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _inspectorsError != null
                    ? IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.orange),
                        onPressed: _loadInspectors,
                        tooltip: 'Retry loading inspectors',
                      )
                    : null,
          ),
          value: basicInfo.inspector.isEmpty ? null : basicInfo.inspector,
          items: _inspectors.isEmpty
              ? [
                  const DropdownMenuItem(
                    value: '',
                    enabled: false,
                    child: Text('No inspectors available'),
                  ),
                ]
              : _inspectors.map((user) {
                  final name = user['name'] as String;
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
          onChanged: _isInspectorsLoading || _inspectors.isEmpty
              ? null
              : (value) {
                  if (value != null && value.isNotEmpty) {
                    notifier.updateInspector(value);
                  }
                },
        ),
        const SizedBox(height: 16),

        // Inspection Frequency
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Inspection Frequency',
            border: OutlineInputBorder(),
          ),
          value: basicInfo.inspectionFrequency.isEmpty ? null : basicInfo.inspectionFrequency,
          items: const [
            DropdownMenuItem(value: 'Annual', child: Text('Annual')),
            DropdownMenuItem(value: 'Semi Annual', child: Text('Semi Annual')),
            DropdownMenuItem(value: 'Quarterly', child: Text('Quarterly')),
          ],
          onChanged: (value) {
            if (value != null) {
              notifier.updateInspectionFrequency(value);
              // Update inspection number options and set value based on frequency
              setState(() {
                switch (value) {
                  case 'Annual':
                    _inspectionNumberOptions = ['1/1'];
                    // Automatically set to 1/1 for Annual
                    notifier.updateInspectionNumber('1/1');
                    break;
                  case 'Semi Annual':
                    _inspectionNumberOptions = ['1/2', '2/2'];
                    // Clear inspection number when frequency changes to Semi Annual
                    notifier.updateInspectionNumber('');
                    break;
                  case 'Quarterly':
                    _inspectionNumberOptions = ['1/4', '2/4', '3/4', '4/4'];
                    // Clear inspection number when frequency changes to Quarterly
                    notifier.updateInspectionNumber('');
                    break;
                  default:
                    _inspectionNumberOptions = [];
                    notifier.updateInspectionNumber('');
                }
              });
            }
          },
        ),
        const SizedBox(height: 16),

        // Inspection Number
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Inspection Number',
            border: OutlineInputBorder(),
          ),
          value: basicInfo.inspectionNumber.isEmpty ? null : basicInfo.inspectionNumber,
          items: _inspectionNumberOptions.isEmpty
              ? [
                  const DropdownMenuItem(
                    value: '',
                    enabled: false,
                    child: Text('Select frequency first'),
                  ),
                ]
              : _inspectionNumberOptions.map((number) {
                  return DropdownMenuItem<String>(
                    value: number,
                    child: Text(number),
                  );
                }).toList(),
          onChanged: _inspectionNumberOptions.isEmpty
              ? null
              : (value) {
                  if (value != null) notifier.updateInspectionNumber(value);
                },
        ),
        const SizedBox(height: 16),

        // Bill To
        TextFormField(
          initialValue: basicInfo.billTo,
          decoration: const InputDecoration(
            labelText: 'Bill To *',
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.updateBillTo,
        ),
        const SizedBox(height: 16),

        // Billing Street
        TextFormField(
          initialValue: basicInfo.billingStreet,
          decoration: const InputDecoration(
            labelText: 'Billing Street',
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.updateBillingStreet,
        ),
        const SizedBox(height: 16),

        // Attention
        TextFormField(
          initialValue: basicInfo.attention,
          decoration: const InputDecoration(
            labelText: 'Billing Attention To',
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.updateAttention,
        ),
        const SizedBox(height: 16),

        // Billing City/State
        TextFormField(
          initialValue: basicInfo.billingCityState,
          decoration: const InputDecoration(
            labelText: 'Billing City/State',
            border: OutlineInputBorder(),
            hintText: 'e.g., Manchester, NH',
          ),
          onChanged: notifier.updateBillingCityState,
        ),
        const SizedBox(height: 16),

        // Contact
        TextFormField(
          initialValue: basicInfo.contact,
          decoration: const InputDecoration(
            labelText: 'Contact *',
            border: OutlineInputBorder(),
          ),
          onChanged: notifier.updateContact,
        ),
        const SizedBox(height: 16),

        // Phone
        TextFormField(
          initialValue: basicInfo.phone,
          decoration: const InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: notifier.updatePhone,
        ),
        const SizedBox(height: 16),

        // Email
        TextFormField(
          initialValue: basicInfo.email,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.updateEmail,
        ),
      ],
    );
  }
}
