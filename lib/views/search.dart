import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchDialog extends StatefulWidget {
  final List<String> searchColumns;
  final void Function(
    String? searchTerm, 
    String? searchColumn, 
    DateTime? startDate, 
    DateTime? endDate
  ) onSearch;

  const SearchDialog({
    super.key, 
    required this.searchColumns,
    required this.onSearch,
  });

  @override
  SearchDialogState createState() => SearchDialogState();
}

class SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? _selectedColumn;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isColumnSearchEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedColumn = widget.searchColumns.isNotEmpty ? widget.searchColumns.first : null;
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
        ? (_startDate ?? DateTime.now()) 
        : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          // Validate end date is not before start date
          if (_startDate != null && picked.isBefore(_startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End date cannot be before start date'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            _endDate = picked;
          }
        }
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _selectedColumn = widget.searchColumns.isNotEmpty ? widget.searchColumns.first : null;
      _startDate = null;
      _endDate = null;
      _isColumnSearchEnabled = false;
    });
    widget.onSearch(null, null, null, null);
    Navigator.of(context).pop();
  }

  void _performSearch() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final searchTerm = _searchController.text.trim().isEmpty 
      ? null 
      : _searchController.text.trim();
    
    // Validate date range
    if (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSearch(
      searchTerm, 
      (_isColumnSearchEnabled && searchTerm != null) ? _selectedColumn : null, 
      _startDate, 
      _endDate
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen and keyboard metrics
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final orientation = mediaQuery.orientation;

    // Calculate available height
    final availableHeight = screenHeight - keyboardHeight - 100; // Subtract app bar and padding

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: orientation == Orientation.landscape 
              ? screenHeight * 0.8 
              : availableHeight,
            minWidth: mediaQuery.size.width * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Search Inspections',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Search Term Input
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Search Term',
                      hintText: 'Enter search text',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 16),

                  // Column Search Toggle
                  if (widget.searchColumns.isNotEmpty)
                    Row(
                      children: [
                        Checkbox(
                          value: _isColumnSearchEnabled,
                          onChanged: (bool? value) {
                            setState(() {
                              _isColumnSearchEnabled = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text('Search in specific column'),
                        ),
                      ],
                    ),

                  // Column Dropdown
                  if (_isColumnSearchEnabled && widget.searchColumns.isNotEmpty)
                    DropdownButtonFormField<String>(
                      value: _selectedColumn,
                      decoration: InputDecoration(
                        labelText: 'Search Column',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: widget.searchColumns
                          .map((column) => DropdownMenuItem(
                                value: column,
                                child: Text(column),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedColumn = value;
                        });
                      },
                    ),
                  const SizedBox(height: 16),

                  // Date Range Picker
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectDate(context, true),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          child: Text(
                            _startDate == null 
                              ? 'Start Date' 
                              : DateFormat('yyyy-MM-dd').format(_startDate!),
                            style: TextStyle(
                              color: _startDate == null 
                                ? Colors.grey 
                                : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _selectDate(context, false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          child: Text(
                            _endDate == null 
                              ? 'End Date' 
                              : DateFormat('yyyy-MM-dd').format(_endDate!),
                            style: TextStyle(
                              color: _endDate == null 
                                ? Colors.grey 
                                : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _clearSearch,
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _performSearch,
                          child: const Text('Search'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}