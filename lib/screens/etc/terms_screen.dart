import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이용 약관 및 개인정보 처리방침'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이용 약관',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildSectionTitle('1. 서문'),
              _buildSectionContent(
                '이 약관은 테니스재미쓰(TennisFun) 앱(이하 "본 앱")의 이용과 관련하여, '
                '본 앱을 제공하는 테니스재미쓰(이하 "회사")와 사용자 간의 권리, 의무 및 책임 사항을 규정합니다. '
                '본 앱을 이용함으로써 사용자는 본 약관에 동의하는 것으로 간주됩니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('2. 서비스 제공'),
              _buildSectionContent(
                '회사는 본 앱을 통해 테니스 매칭, 경기 일정 관리, 사용자 프로필 관리 등의 서비스를 제공합니다. '
                '회사는 지속적인 서비스 제공을 위해 노력하지만, 기술적 문제나 기타 사유로 인해 서비스가 중단될 수 있습니다. '
                '회사는 서비스의 내용, 이용 방법, 이용 시간을 적절히 변경할 수 있으며, 이러한 변경 사항은 사전에 공지합니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('3. 사용자 계정'),
              _buildSectionContent(
                '사용자는 본 앱을 이용하기 위해 정확하고 완전한 정보로 계정을 생성해야 합니다. '
                '사용자는 자신의 계정 정보를 유지하고, 타인에게 계정을 양도하거나 대여할 수 없습니다. '
                '계정 정보가 부정확하거나 허위인 경우, 회사는 계정을 삭제하거나 서비스 이용을 제한할 수 있습니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('4. 개인정보 보호'),
              _buildSectionContent(
                '회사는 사용자의 개인정보를 보호하기 위해 노력하며, 관련 법령에 따라 개인정보를 처리합니다. '
                '사용자의 개인정보 수집 및 이용에 관한 상세 내용은 본 앱의 개인정보 처리방침에 따릅니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('5. 사용자의 의무'),
              _buildSectionContent(
                '사용자는 본 앱을 이용함에 있어 관련 법령, 본 약관, 이용 안내 등 회사가 공지하는 사항을 준수해야 합니다. '
                '사용자는 타인의 권리를 침해하거나, 공공질서 및 미풍양속을 저해하는 행위를 해서는 안 됩니다. '
                '본 앱의 무단 복제, 배포, 변조 등의 행위를 금지합니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('6. 서비스 이용 제한'),
              _buildSectionContent(
                '회사는 사용자가 본 약관을 위반하거나 부적절한 행위를 할 경우, 서비스 이용을 일시적 또는 영구적으로 제한할 수 있습니다. '
                '서비스 이용 제한에 대한 자세한 사항은 회사의 정책에 따릅니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('7. 면책 조항'),
              _buildSectionContent(
                '회사는 천재지변, 전쟁, 테러, 해킹 등 불가항력적인 사유로 인해 발생한 서비스 중단에 대해 책임을 지지 않습니다. '
                '회사는 사용자가 본 앱을 이용함으로써 얻은 정보나 자료의 정확성, 신뢰성, 완전성에 대해 보장하지 않으며, 이에 따른 손해에 대해 책임을 지지 않습니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('8. 약관의 변경'),
              _buildSectionContent(
                '회사는 필요에 따라 본 약관을 변경할 수 있으며, 변경된 약관은 본 앱을 통해 공지합니다. '
                '사용자는 변경된 약관에 동의하지 않을 경우, 서비스 이용을 중단하고 계정을 삭제할 수 있습니다. '
                '변경된 약관 공지 이후에도 서비스를 계속 이용할 경우, 변경된 약관에 동의한 것으로 간주됩니다.',
              ),
              SizedBox(height: 16),
              _buildSectionTitle('9. 기타'),
              _buildSectionContent(
                '본 약관에 명시되지 않은 사항은 관련 법령 및 상관례에 따릅니다. '
                '본 약관은 대한민국 법률에 따라 해석되고, 이행됩니다.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
