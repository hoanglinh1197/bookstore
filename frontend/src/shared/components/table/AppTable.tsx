import Table from 'react-bootstrap/Table';

interface Props{
  tableType: String;
}

function AppTable({tableType}: Props) {
  return (
    <Table striped bordered hover size="sm">
      <thead>
        <tr>
          <th>STT</th>
          <th>Tài khoản</th>
          <th>Năm sinh</th>
          <th>Địa chỉ</th>
          <th>Gmail</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>1</td>
          <td>Mark</td>
          <td>1984</td>
          <td>10 đường abc</td>
          <td>@mdo</td>
        </tr>
      </tbody>
    </Table>
  );
}

export default AppTable;