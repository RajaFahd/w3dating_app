import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+1';
  String _selectedCountryFlag = 'us';
  final bool _isLoading = false;

  // Comprehensive list of countries with their codes and flags
  final Map<String, Map<String, String>> _countries = {
    '+1': {'name': 'United States', 'flag': 'us'},
    '+7': {'name': 'Russia', 'flag': 'ru'},
    '+20': {'name': 'Egypt', 'flag': 'eg'},
    '+27': {'name': 'South Africa', 'flag': 'za'},
    '+30': {'name': 'Greece', 'flag': 'gr'},
    '+31': {'name': 'Netherlands', 'flag': 'nl'},
    '+32': {'name': 'Belgium', 'flag': 'be'},
    '+33': {'name': 'France', 'flag': 'fr'},
    '+34': {'name': 'Spain', 'flag': 'es'},
    '+36': {'name': 'Hungary', 'flag': 'hu'},
    '+39': {'name': 'Italy', 'flag': 'it'},
    '+40': {'name': 'Romania', 'flag': 'ro'},
    '+41': {'name': 'Switzerland', 'flag': 'ch'},
    '+43': {'name': 'Austria', 'flag': 'at'},
    '+44': {'name': 'United Kingdom', 'flag': 'gb'},
    '+45': {'name': 'Denmark', 'flag': 'dk'},
    '+46': {'name': 'Sweden', 'flag': 'se'},
    '+47': {'name': 'Norway', 'flag': 'no'},
    '+48': {'name': 'Poland', 'flag': 'pl'},
    '+49': {'name': 'Germany', 'flag': 'de'},
    '+51': {'name': 'Peru', 'flag': 'pe'},
    '+52': {'name': 'Mexico', 'flag': 'mx'},
    '+53': {'name': 'Cuba', 'flag': 'cu'},
    '+54': {'name': 'Argentina', 'flag': 'ar'},
    '+55': {'name': 'Brazil', 'flag': 'br'},
    '+56': {'name': 'Chile', 'flag': 'cl'},
    '+57': {'name': 'Colombia', 'flag': 'co'},
    '+58': {'name': 'Venezuela', 'flag': 've'},
    '+60': {'name': 'Malaysia', 'flag': 'my'},
    '+61': {'name': 'Australia', 'flag': 'au'},
    '+62': {'name': 'Indonesia', 'flag': 'id'},
    '+63': {'name': 'Philippines', 'flag': 'ph'},
    '+64': {'name': 'New Zealand', 'flag': 'nz'},
    '+65': {'name': 'Singapore', 'flag': 'sg'},
    '+66': {'name': 'Thailand', 'flag': 'th'},
    '+81': {'name': 'Japan', 'flag': 'jp'},
    '+82': {'name': 'South Korea', 'flag': 'kr'},
    '+84': {'name': 'Vietnam', 'flag': 'vn'},
    '+86': {'name': 'China', 'flag': 'cn'},
    '+90': {'name': 'Turkey', 'flag': 'tr'},
    '+91': {'name': 'India', 'flag': 'in'},
    '+92': {'name': 'Pakistan', 'flag': 'pk'},
    '+93': {'name': 'Afghanistan', 'flag': 'af'},
    '+94': {'name': 'Sri Lanka', 'flag': 'lk'},
    '+95': {'name': 'Myanmar', 'flag': 'mm'},
    '+98': {'name': 'Iran', 'flag': 'ir'},
    '+212': {'name': 'Morocco', 'flag': 'ma'},
    '+213': {'name': 'Algeria', 'flag': 'dz'},
    '+216': {'name': 'Tunisia', 'flag': 'tn'},
    '+218': {'name': 'Libya', 'flag': 'ly'},
    '+220': {'name': 'Gambia', 'flag': 'gm'},
    '+221': {'name': 'Senegal', 'flag': 'sn'},
    '+222': {'name': 'Mauritania', 'flag': 'mr'},
    '+223': {'name': 'Mali', 'flag': 'ml'},
    '+224': {'name': 'Guinea', 'flag': 'gn'},
    '+225': {'name': 'Ivory Coast', 'flag': 'ci'},
    '+226': {'name': 'Burkina Faso', 'flag': 'bf'},
    '+227': {'name': 'Niger', 'flag': 'ne'},
    '+228': {'name': 'Togo', 'flag': 'tg'},
    '+229': {'name': 'Benin', 'flag': 'bj'},
    '+230': {'name': 'Mauritius', 'flag': 'mu'},
    '+231': {'name': 'Liberia', 'flag': 'lr'},
    '+232': {'name': 'Sierra Leone', 'flag': 'sl'},
    '+233': {'name': 'Ghana', 'flag': 'gh'},
    '+234': {'name': 'Nigeria', 'flag': 'ng'},
    '+235': {'name': 'Chad', 'flag': 'td'},
    '+236': {'name': 'Central African Republic', 'flag': 'cf'},
    '+237': {'name': 'Cameroon', 'flag': 'cm'},
    '+238': {'name': 'Cape Verde', 'flag': 'cv'},
    '+239': {'name': 'Sao Tome and Principe', 'flag': 'st'},
    '+240': {'name': 'Equatorial Guinea', 'flag': 'gq'},
    '+241': {'name': 'Gabon', 'flag': 'ga'},
    '+242': {'name': 'Congo', 'flag': 'cg'},
    '+243': {'name': 'DR Congo', 'flag': 'cd'},
    '+244': {'name': 'Angola', 'flag': 'ao'},
    '+245': {'name': 'Guinea-Bissau', 'flag': 'gw'},
    '+246': {'name': 'British Indian Ocean Territory', 'flag': 'io'},
    '+248': {'name': 'Seychelles', 'flag': 'sc'},
    '+249': {'name': 'Sudan', 'flag': 'sd'},
    '+250': {'name': 'Rwanda', 'flag': 'rw'},
    '+251': {'name': 'Ethiopia', 'flag': 'et'},
    '+252': {'name': 'Somalia', 'flag': 'so'},
    '+253': {'name': 'Djibouti', 'flag': 'dj'},
    '+254': {'name': 'Kenya', 'flag': 'ke'},
    '+255': {'name': 'Tanzania', 'flag': 'tz'},
    '+256': {'name': 'Uganda', 'flag': 'ug'},
    '+257': {'name': 'Burundi', 'flag': 'bi'},
    '+258': {'name': 'Mozambique', 'flag': 'mz'},
    '+260': {'name': 'Zambia', 'flag': 'zm'},
    '+261': {'name': 'Madagascar', 'flag': 'mg'},
    '+262': {'name': 'Reunion', 'flag': 're'},
    '+263': {'name': 'Zimbabwe', 'flag': 'zw'},
    '+264': {'name': 'Namibia', 'flag': 'na'},
    '+265': {'name': 'Malawi', 'flag': 'mw'},
    '+266': {'name': 'Lesotho', 'flag': 'ls'},
    '+267': {'name': 'Botswana', 'flag': 'bw'},
    '+268': {'name': 'Eswatini', 'flag': 'sz'},
    '+269': {'name': 'Comoros', 'flag': 'km'},
    '+290': {'name': 'Saint Helena', 'flag': 'sh'},
    '+291': {'name': 'Eritrea', 'flag': 'er'},
    '+297': {'name': 'Aruba', 'flag': 'aw'},
    '+298': {'name': 'Faroe Islands', 'flag': 'fo'},
    '+299': {'name': 'Greenland', 'flag': 'gl'},
    '+350': {'name': 'Gibraltar', 'flag': 'gi'},
    '+351': {'name': 'Portugal', 'flag': 'pt'},
    '+352': {'name': 'Luxembourg', 'flag': 'lu'},
    '+353': {'name': 'Ireland', 'flag': 'ie'},
    '+354': {'name': 'Iceland', 'flag': 'is'},
    '+355': {'name': 'Albania', 'flag': 'al'},
    '+356': {'name': 'Malta', 'flag': 'mt'},
    '+357': {'name': 'Cyprus', 'flag': 'cy'},
    '+358': {'name': 'Finland', 'flag': 'fi'},
    '+359': {'name': 'Bulgaria', 'flag': 'bg'},
    '+370': {'name': 'Lithuania', 'flag': 'lt'},
    '+371': {'name': 'Latvia', 'flag': 'lv'},
    '+372': {'name': 'Estonia', 'flag': 'ee'},
    '+373': {'name': 'Moldova', 'flag': 'md'},
    '+374': {'name': 'Armenia', 'flag': 'am'},
    '+375': {'name': 'Belarus', 'flag': 'by'},
    '+376': {'name': 'Andorra', 'flag': 'ad'},
    '+377': {'name': 'Monaco', 'flag': 'mc'},
    '+378': {'name': 'San Marino', 'flag': 'sm'},
    '+379': {'name': 'Vatican City', 'flag': 'va'},
    '+380': {'name': 'Ukraine', 'flag': 'ua'},
    '+381': {'name': 'Serbia', 'flag': 'rs'},
    '+382': {'name': 'Montenegro', 'flag': 'me'},
    '+383': {'name': 'Kosovo', 'flag': 'xk'},
    '+385': {'name': 'Croatia', 'flag': 'hr'},
    '+386': {'name': 'Slovenia', 'flag': 'si'},
    '+387': {'name': 'Bosnia and Herzegovina', 'flag': 'ba'},
    '+389': {'name': 'North Macedonia', 'flag': 'mk'},
    '+420': {'name': 'Czech Republic', 'flag': 'cz'},
    '+421': {'name': 'Slovakia', 'flag': 'sk'},
    '+423': {'name': 'Liechtenstein', 'flag': 'li'},
    '+500': {'name': 'Falkland Islands', 'flag': 'fk'},
    '+501': {'name': 'Belize', 'flag': 'bz'},
    '+502': {'name': 'Guatemala', 'flag': 'gt'},
    '+503': {'name': 'El Salvador', 'flag': 'sv'},
    '+504': {'name': 'Honduras', 'flag': 'hn'},
    '+505': {'name': 'Nicaragua', 'flag': 'ni'},
    '+506': {'name': 'Costa Rica', 'flag': 'cr'},
    '+507': {'name': 'Panama', 'flag': 'pa'},
    '+508': {'name': 'Saint Pierre and Miquelon', 'flag': 'pm'},
    '+509': {'name': 'Haiti', 'flag': 'ht'},
    '+590': {'name': 'Guadeloupe', 'flag': 'gp'},
    '+591': {'name': 'Bolivia', 'flag': 'bo'},
    '+592': {'name': 'Guyana', 'flag': 'gy'},
    '+593': {'name': 'Ecuador', 'flag': 'ec'},
    '+594': {'name': 'French Guiana', 'flag': 'gf'},
    '+595': {'name': 'Paraguay', 'flag': 'py'},
    '+596': {'name': 'Martinique', 'flag': 'mq'},
    '+597': {'name': 'Suriname', 'flag': 'sr'},
    '+598': {'name': 'Uruguay', 'flag': 'uy'},
    '+599': {'name': 'Curacao', 'flag': 'cw'},
    '+670': {'name': 'Timor-Leste', 'flag': 'tl'},
    '+672': {'name': 'Antarctica', 'flag': 'aq'},
    '+673': {'name': 'Brunei', 'flag': 'bn'},
    '+674': {'name': 'Nauru', 'flag': 'nr'},
    '+675': {'name': 'Papua New Guinea', 'flag': 'pg'},
    '+676': {'name': 'Tonga', 'flag': 'to'},
    '+677': {'name': 'Solomon Islands', 'flag': 'sb'},
    '+678': {'name': 'Vanuatu', 'flag': 'vu'},
    '+679': {'name': 'Fiji', 'flag': 'fj'},
    '+680': {'name': 'Palau', 'flag': 'pw'},
    '+681': {'name': 'Wallis and Futuna', 'flag': 'wf'},
    '+682': {'name': 'Cook Islands', 'flag': 'ck'},
    '+683': {'name': 'Niue', 'flag': 'nu'},
    '+685': {'name': 'Samoa', 'flag': 'ws'},
    '+686': {'name': 'Kiribati', 'flag': 'ki'},
    '+687': {'name': 'New Caledonia', 'flag': 'nc'},
    '+688': {'name': 'Tuvalu', 'flag': 'tv'},
    '+689': {'name': 'French Polynesia', 'flag': 'pf'},
    '+690': {'name': 'Tokelau', 'flag': 'tk'},
    '+691': {'name': 'Micronesia', 'flag': 'fm'},
    '+692': {'name': 'Marshall Islands', 'flag': 'mh'},
    '+850': {'name': 'North Korea', 'flag': 'kp'},
    '+852': {'name': 'Hong Kong', 'flag': 'hk'},
    '+853': {'name': 'Macau', 'flag': 'mo'},
    '+855': {'name': 'Cambodia', 'flag': 'kh'},
    '+856': {'name': 'Laos', 'flag': 'la'},
    '+880': {'name': 'Bangladesh', 'flag': 'bd'},
    '+886': {'name': 'Taiwan', 'flag': 'tw'},
    '+960': {'name': 'Maldives', 'flag': 'mv'},
    '+961': {'name': 'Lebanon', 'flag': 'lb'},
    '+962': {'name': 'Jordan', 'flag': 'jo'},
    '+963': {'name': 'Syria', 'flag': 'sy'},
    '+964': {'name': 'Iraq', 'flag': 'iq'},
    '+965': {'name': 'Kuwait', 'flag': 'kw'},
    '+966': {'name': 'Saudi Arabia', 'flag': 'sa'},
    '+967': {'name': 'Yemen', 'flag': 'ye'},
    '+968': {'name': 'Oman', 'flag': 'om'},
    '+970': {'name': 'Palestine', 'flag': 'ps'},
    '+971': {'name': 'United Arab Emirates', 'flag': 'ae'},
    '+972': {'name': 'Israel', 'flag': 'il'},
    '+973': {'name': 'Bahrain', 'flag': 'bh'},
    '+974': {'name': 'Qatar', 'flag': 'qa'},
    '+975': {'name': 'Bhutan', 'flag': 'bt'},
    '+976': {'name': 'Mongolia', 'flag': 'mn'},
    '+977': {'name': 'Nepal', 'flag': 'np'},
    '+992': {'name': 'Tajikistan', 'flag': 'tj'},
    '+993': {'name': 'Turkmenistan', 'flag': 'tm'},
    '+994': {'name': 'Azerbaijan', 'flag': 'az'},
    '+995': {'name': 'Georgia', 'flag': 'ge'},
    '+996': {'name': 'Kyrgyzstan', 'flag': 'kg'},
    '+998': {'name': 'Uzbekistan', 'flag': 'uz'},
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding'),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'Please Enter your Phone\nNumber',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Phone input container
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF383840),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Country code selector
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://flagcdn.com/w40/$_selectedCountryFlag.png',
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.flag, color: Colors.white54, size: 20);
                                  },
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _showCountryPicker(context),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _selectedCountryCode,
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical divider
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.white24,
                          ),

                          // Phone number input
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3F80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isLoading ? null : _goToPassword,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToPassword() async {
    final phoneNumber = _phoneController.text.replaceAll(RegExp(r"[^0-9]"), '').trim();
    if (phoneNumber.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      '/password',
      arguments: {
        'phone_number': phoneNumber,
        'country_code': _selectedCountryCode,
        'register': false,
      },
    );
  }

  void _showCountryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF2A2B30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: 400,
            width: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Select Country Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _countries.length,
                    itemBuilder: (context, index) {
                      final code = _countries.keys.elementAt(index);
                      final country = _countries[code]!;
                      return ListTile(
                        leading: Image.network(
                          'https://flagcdn.com/w40/${country['flag']}.png',
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.flag, color: Colors.white54, size: 28);
                          },
                        ),
                        title: Text(
                          '$code - ${country['name']}',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCountryCode = code;
                            _selectedCountryFlag = country['flag']!;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

